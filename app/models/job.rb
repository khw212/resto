class Job < ActiveRecord::Base
  belongs_to :employer
  belongs_to :job_category
  belongs_to :position_type
  belongs_to :education
  
  has_many :job_applications
  has_many :job_seeker, :through => :job_applications
  
  named_scope :from_employer, lambda { |id|
     { :conditions => { :employer_id => id } }
  }
  
  named_scope :with_job_applications, :include => [:job_applications]
  
#  named_scope :by_keyword, lambda { |keyword|
#    Job.position_name_like_or_general_description_like_or_position_type_name_en_like_or_job_category_name_en_like(keyword) }
#  #scope_procedure :location, lambda {
  
  default_scope :include => [:employer, :job_category, :position_type], :order => 'created_at DESC'
  
  attr_accessible :position_name, :city, :state, :job_category_id, :position_type_id, :education_id,
    :experience_level, :general_description, :job_requirements, :postal_code
    
  validates_presence_of   :position_name, :general_description, :city, :state, :postal_code, :job_category_id, :position_type_id
  validates_associated    :job_category, :position_type, :education
  validates_inclusion_of  :state, :in => Carmen::state_codes
  validates_format_of     :postal_code,
                    :with => %r{\d{5}(-\d{4})?},
                    :message => "should be 12345 or 12345-1234"
  
  
end
