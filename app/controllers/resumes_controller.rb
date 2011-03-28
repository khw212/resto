class ResumesController < ApplicationController

  # role lock.
  before_filter :require_user
  before_filter :require_job_seeker

  def update
    if current_user.admin?
      @job_seeker = JobSeeker.find(params[:job_seeker_id])
    else
      @job_seeker = @current_user.profileable
    end
    @resume = @job_seeker.resume
    
    respond_to do |format|
      if @resume.update_attributes(params[:resume])
        flash[:notice] = t('resto.messages.flash.resume.update')
        format.html { redirect_to(@job_seeker) }
        format.js   { render :json => @job_seeker }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resume.errors, :status => :unprocessable_entity }
      end
    end
  end

end
