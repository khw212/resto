class Employer < ActiveRecord::Base
  has_one :user,    :as => :profileable
  
  #address
  validates_inclusion_of :state, :in => Carmen::state_codes
  
  belongs_to :business_type
  has_many :jobs
  
  default_scope :include => [ :business_type ]
  named_scope   :with_user, :include => [:user]
  
  has_many :job_histories
  has_many :resumes, :through => :job_histories
  
  has_many :job_applications
  
  #attr_accessible :business_name, :business_type_id, :address, :city, :state, :postal_code, :telephone, :confidential
  attr_protected :jobs, :job_histories, :resumes, :confirmed
  validates_presence_of   :business_name, :business_type, :city, :state, :postal_code
  validates_associated    :business_type
  validates_inclusion_of  :state, :in => Carmen::state_codes
  validates_format_of     :postal_code,
                    :with => %r{\d{5}(-\d{4})?},
                    :message => "should be 12345 or 12345-1234"
                    
  validates_uniqueness_of :subpath, :allow_nil => true, :allow_blank => true

  def name
    self.business_name
  end
end
