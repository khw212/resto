class JobSeeker < ActiveRecord::Base
  has_one :user,    :as => :profileable
  #address
  validates_inclusion_of :state, :in => Carmen::state_codes

  # delete on job seeker delete 
  has_one :resume, :dependent => :destroy
  # initialize resume
  after_create { |record| record.resume= Resume.new }
  
  has_many :job_applications
  has_many :jobs, :through => :job_applications
  
  attr_protected :resume
  validates_presence_of   :name, :gender, :city, :state
  validates_inclusion_of  :state, :in => Carmen::state_codes
  validates_format_of     :postal_code,
                    :with => %r{\d{5}(-\d{4})?},
                    :message => "should be 12345 or 12345-1234"
end
