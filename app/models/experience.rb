class Experience < ActiveRecord::Base
  belongs_to :resume
  belongs_to :job_category
  
  attr_accessible                    :job_category_id, :year_used, :years_of_experience
  validates_presence_of     :resume, :job_category_id, :year_used, :years_of_experience
  validates_associated      :job_category
  validates_numericality_of :year_used, :greater_than => 1900, :less_than => 2500 
  validates_numericality_of :years_of_experience
end
