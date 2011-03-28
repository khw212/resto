class Resume < ActiveRecord::Base
  belongs_to :job_seeker
  belongs_to :education
  belongs_to :desired_position_type, :class_name => 'PositionType'
  
  has_many :experiences
  has_many :job_categories, :through => :experiences
  
  has_many :job_histories
  has_many :employers, :through => :job_histories
  
  attr_protected :experiences, :job_categories, :job_histories, :employers, :job_seeker_id
  validates_associated :job_seeker
end
