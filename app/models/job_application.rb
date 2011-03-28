class JobApplication < ActiveRecord::Base

  belongs_to :job
  belongs_to :job_seeker
  belongs_to :employer
  
  # i18n message: job_application.status.0 == normal.
  # usage: @job.job_applications.favored # to get all favored job seeker
  named_scope :unread,    :conditions => { :status => 0 }
  named_scope :read,      :conditions => { :status => 1 }
  named_scope :favored,   :conditions => { :status => 2 }  
  named_scope :rejected,  :conditions => { :status => 3 }

  validates_inclusion_of :status, :in => 0..3
  
  #not needed since there's no update_attributes(params[:job_application] in controller.
  #attr_protected :employer_id, :job_seeker_id, 

end
