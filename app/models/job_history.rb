class JobHistory < ActiveRecord::Base
  belongs_to :employer
  belongs_to :resume
  
  attr_accessible                     :employer_name, :employer_city, :employer_state, :position
  validates_presence_of   :resume_id, :employer_name, :employer_city, :employer_state, :position
  validates_inclusion_of  :employer_state, :in => Carmen::state_codes
end
