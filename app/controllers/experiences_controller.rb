class ExperiencesController < ApplicationController

  # role lock.
  before_filter :require_user
  before_filter :require_job_seeker
  before_filter :find_data!
  
  def create
    experience = Experience.new(params[:experience])
    experience.resume = @resume
    respond_to do |format|
      if experience.save
        flash[:notice] = t('resto.messages.flash.resume.update')
        format.html { redirect_to(@job_seeker) }
        format.js   { render :json => experience }
        format.xml  { head :ok }
      else
        flash[:notice] = experience.errors.full_messages
        format.html { redirect_to(@job_seeker) }
        format.xml  { render :xml => experience.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    o = @resume.experiences.find(params[:id])
    o.destroy
    
    respond_to do |format|
      format.html { redirect_to(@job_seeker) }
      format.xml  { head :ok }
    end
  end
  
  private
    def find_data!
      if current_user.admin?
        @job_seeker = JobSeeker.find(params[:job_seeker_id])
      else
        @job_seeker = @current_user.profileable
      end
      @resume = @job_seeker.resume
    end

end
