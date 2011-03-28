class JobSeekersController < ApplicationController

  before_filter :require_user,      :only => [:update, :index, :show]
  before_filter :require_job_seeker,:only => [:update]

  inherit_resources
  
  actions :index, :show, :update
  respond_to :html, :js, :json
  
  def update
    @job_seeker = current_user.profileable
    update!{ :back }
  end
  
  def index
    # job seeker redirected to own resume
    if me_job_seeker? && !me_admin?
      redirect_to job_seeker_path(current_user.profileable_id) and return
    end
    
    @search = JobSeeker.search
    
    
    if me_admin?
      
      unless params[:name].blank?
        @search = @search.name_like(params[:name])
      end

      unless params[:state].blank?
        @search = @search.state_like(params[:state])
      end
      
    #only employer
    elsif me_employer?
 
      unless params[:city].blank?
        @search = @search.resume_preferred_locations_like("#{ params[:city] },")
      end

      unless params[:state].blank?
        @search = @search.resume_preferred_locations_like(", #{ params[:state] }")
      end
            
      unless params[:job_category].blank?
        @search = @search.resume_experiences_job_category_id_equals(params[:job_category]) 
      end
      
      unless params[:desired_position_type].blank?
        @search = @search.resume_desired_position_type_id_equals(params[:desired_position_type]) 
      end

    end
    
    #only admin has access to private resumes in index
    unless me_admin?
      @search = @search.resume_public_eq(true)
    end
    
    @job_seekers = @search.paginate(:page => params[:page], :per_page => params[:per_page] || 10, :include => :user)
    index!
  end

  def show
    @job_seeker = JobSeeker.find(params[:id], :include =>  { :resume => [ {:experiences => :job_category}, :job_histories, :education] } )
    @resume     = @job_seeker.resume
    
    #protects private resume
    if @resume.public == false
      # employer whose job is applied for can also see resume
      if me_employer? && !me_admin?
        unless @job_seeker.job_applications.find_by_employer_id(current_user.profileable_id)
          render_error(401) and return
        end
      else
        # can view own resume
        unless my_resume?(@resume)
          render_error(401) and return
        end
      end
    end
    
    show!
  end

end
