class JobHistoriesController < ApplicationController

  # role lock.
  before_filter :require_user
  before_filter :require_job_seeker
  before_filter :find_data!

  def create
    job_history = JobHistory.new(params[:job_history])
    respond_to do |format|
      if @resume.job_histories << job_history
        flash[:notice] = t('resto.messages.flash.resume.update')
        format.html { redirect_to(@job_seeker) }
        format.js   { render :json => job_history }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@job_seeker) }
        format.xml  { render :xml => @resume.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    o = @resume.job_histories.find(params[:id])
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
