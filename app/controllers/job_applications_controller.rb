class JobApplicationsController < ApplicationController
  # role lock.
  before_filter :require_user
  before_filter :require_employer,    :only => [:update, :show]
  before_filter :init_employer!,      :only => [:update, :show]
  before_filter :require_job_seeker,  :only => [:create, :index]
  before_filter :init_job_seeker!,    :only => [:create, :index]
  
  #inherit_resources
  #actions :all
  ##respond_to :html, :js, :json

  # employer part to show application is at show
  def index
    @job_applications = JobApplication.paginate_by_job_seeker_id(@job_seeker.id,
      :include => [:job],
      :page => params[:page], 
      :per_page => params[:per_page] || 5,
      :order => 'updated_at DESC')
  end

  def create
    job = Job.find(params[:job_application][:job_id])

    # will not overwrite existing job_seeker application associated with this job
    @job_application = job.job_applications.find_or_initialize_by_job_seeker_id(@job_seeker.id)
    @job_application.employer = job.employer
    @job_application.status = 0
    respond_to do |format|
      if @job_application.save
        flash[:notice] = t('resto.messages.application_submitted')
        format.html { redirect_to(job) }
        format.js   { render :json => @job_application }
        format.xml  { head :ok }
      else
        flash[:notice] = @job_application.errors.full_messages
        format.html { redirect_to(job) }
        format.xml  { render :xml => @job_application.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    o = @job_seeker.job_applications.find(params[:id])
    o.destroy
    
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end
  
  def show
    job = @employer.jobs.find(params[:job_id])
    @job_application = job.job_applications.find_by_id(params[:id], :include => [:job, :job_seeker])
    @job_application.update_attribute(:status, 1)
    respond_to do |format|
      flash[:notice] = t('flash.actions.update.notice')
      format.html { redirect_to(job_seeker_path(@job_application.job_seeker)) }
      format.js   { render :json => @job_application.job_seeker }
      format.xml  { head :ok }
    end
  end
  
  def update
    job = @employer.jobs.find(params[:job_id])
    @job_application = job.job_applications.find_by_id(params[:id])
    @job_application.status = params[:status]
    respond_to do |format|
      if @job_application.save
        flash[:notice] = t('flash.actions.update.notice')
        format.html { redirect_to(applicants_job_path(job.id)) }
        format.js   { render :json => @job_application }
        format.xml  { head :ok }
      else
        format.html { redirect_to(applicants_job_path(job.id)) }
        format.xml  { render :xml => @job_application.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
    #TODO: extract to application_controller
    def init_job_seeker!
      if current_user.admin?
        #@job_seeker = JobSeeker.find(params[:job_seeker_id])
        #TODO: error--admin cannot apply for jobs!!
      else
        @job_seeker = @current_user.profileable
      end
    end
    
    def init_employer!
      if current_user.admin?
        #@job_seeker = JobSeeker.find(params[:job_seeker_id])
        #TODO: error--admin cannot apply for jobs!!
      else
        @employer = @current_user.profileable
      end
    end
end
