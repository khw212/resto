class User < ActiveRecord::Base
  attr_accessible :email, :login, :password, :password_confirmation
  #attr_protected :profileable_id, :profileable_type, :active

  acts_as_authentic do |c|
    # user should have either a login or an email
    c.merge_validates_length_of_login_field_options(:allow_nil => true, :allow_blank => true)
    c.merge_validates_format_of_login_field_options(:allow_nil => true, :allow_blank => true, :with => /\A\w[\w\.\-]+$/)
    c.merge_validates_uniqueness_of_login_field_options(:allow_nil => true, :allow_blank => true)
    c.validate_email_field(false)
  end
  
  validates_length_of :email, :allow_nil => true, :allow_blank => true, :within => 6..50
  validates_format_of :email, :allow_nil => true, :allow_blank => true, :with => Authlogic::Regex.email, 
    :message => I18n.t('error_messages.email_invalid', :default => "should look like an email address.")
  
  validates_presence_of :login
  validates_presence_of :email, :if => Proc.new { |user| user.login.blank? }

  # each user account belongs to a certain profile
  # Employer, JobSeeker, or Admin
  belongs_to :profileable, :polymorphic => true
  accepts_nested_attributes_for :profileable

  
  named_scope :with_profile, lambda { {:include => [:profileable]} }
  #named_scope :without_profile, lambda { {:include => []} }
  #default_scope :include => [:profileable]
  
  def self.find_by_login_or_email(login)
    find_by_login(login) || find_by_email(login)
  end
  
  def build_profileable(params)

    role = params[:profileable_attributes][:profileable_type]
    a    = params[:profileable_attributes].except :profileable_type, :id

    if self.profileable
      self.profileable.update_attributes(a)
    else
      self.profileable = case role
        when "Employer"
          Employer.new(a)
        when "JobSeeker"        
          JobSeeker.new(a)
        when "Admin"
          Admin.new(a)
        when "Moderator"
          Moderator.new(a)
      end
    end

  end

  # users role  
  def employer?
    self.profileable === Employer
  end
  
  def job_seeker?
    self.profileable === JobSeeker
  end
  
  def admin?
    self.profileable === Admin
  end
  
  def moderator?
    self.profileable === Moderator
  end

end
