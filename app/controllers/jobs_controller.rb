class JobsController < ApplicationController

  # role lock.
  before_filter :require_user,      :only => [:new, :create, :edit, :update, :destroy, :applicants]
  before_filter :require_employer,  :only => [:new, :create, :edit, :update, :destroy, :applicants]
  
  trap_door :only => :create
  
  # 
  inherit_resources 
  respond_to :html, :js, :json
  
  def subpath
    if params[:subpath]
      @employer = Employer.user_active_eq(true).find_by_subpath(params[:subpath])
    end
    render_not_found_error and return unless @employer
    
    options = { :page => params[:page], :per_page => params[:per_page] || 10 }
    options[:include] = [:job_applications] if me_job_seeker?
    @search = Job.search.employer_id_eq(@employer.id)
    @jobs   = @search.paginate(options)
    render :action => :index
  end
  
  def show
    unless session[:job_search_path].blank?
      @job_search_path = session[:job_search_path]
    end
    #@job = Job.find(params[:id])
    show!
  end
  
  def applicants
    if me_admin?
      @job = Job.find(params[:id], :include => {:job_applications => :job_seeker})
    else
      @job = @current_user.profileable.jobs.find(params[:id], :include => {:job_applications => :job_seeker})
    end
    @job_applications = @job.job_applications
    render    
  end
  
  def index
    # if this page is a search result, save in sesion
    unless request.query_string.blank?
      session[:job_search_path] = jobs_path + '?' + request.query_string
    else
      session[:job_search_path] = nil
    end

    options = { :page => params[:page], :per_page => params[:per_page] || 10 }
    options[:include] = [:job_applications] if me_job_seeker?
    
    # keyword are english only.
    @search = Job.position_name_like_or_general_description_like_or_position_type_name_en_like_or_job_category_name_en_like(params[:q])
    @search = @search.postal_code_like_or_city_like_or_state_like(params[:l])
    @jobs   = @search.paginate(options)
	index!
  end
  
  def new
    @job = Job.new
    new!
  end
  
  def create
    employer = params[:job][:employer_id]
    params[:job].except!(:employer_id)
    @job = Job.new(params[:job])
    if me_admin?
      @job.employer_id = employer
    else
      @job.employer = @current_user.profileable
    end
    create!
  end
  
  def update
    employer = params[:job][:employer_id]
    params[:job].except!(:employer_id)
    if me_admin?
      @job = Job.find(params[:id])
      @job.employer_id = employer
    else
      @job = @current_user.profileable.jobs.find(params[:id])
    end
    update!
  end
  
  def destroy
    if me_admin?
      @job = Job.find(params[:id])
    else
      @job = @current_user.profileable.jobs.find(params[:id])
    end
    destroy!
  end
  
end
