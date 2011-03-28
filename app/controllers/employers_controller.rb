class EmployersController < ApplicationController

  before_filter :require_user,      :only => [:index, :show]
  before_filter :require_employer,  :only => [:index]
  before_filter :require_admin,     :only => [:pending, :confirm, :decline, :assign_subpath]

  inherit_resources
  actions :index, :show
  respond_to :html, :js, :json
  
  def pending
    @search    = Employer.search
    @search    = @search.confirmed_eq_or_confirmed_eq(['f','d'])
    @employers = @search.paginate(:page => params[:page], :per_page => params[:per_page] || 10, :include => [:user], :order => 'confirmed DESC')
  end
  
  def confirm
    @employer  = Employer.find(params[:id], :include => :user)
    @employer.confirmed = 't'
    @employer.user.active = true
    if @employer.save && @employer.user.save
      flash[:notice] = t('resto.messages.account.employer_confirmed', :email => @employer.user.email)
      Mailer.deliver_employer_approved(
        :recipients => @employer.user.email,
        :body => {
          :business_name => @employer.business_name,
          :host_name => request.domain.split('.').first
        })
    else
      flash[:notice] = @employer.errors.full_messages
    end
    redirect_to pending_employers_path
  end
  
  def decline
    @employer  = Employer.find(params[:id])
    @employer.confirmed = 'd'
    if @employer.save
      flash[:notice] = t('resto.messages.account.employer_declined', :email => @employer.user.email)
      Mailer.deliver_employer_declined(
        :recipients => @employer.user.email,
        :body => {
          :business_name => @employer.business_name,
          :host_name => request.domain.split('.').first
        })
    else
      flash[:notice] = @employer.errors.full_messages
    end
    redirect_to pending_employers_path  
  end
  
  def assign_subpath
    @employer = Employer.find(params[:id])
    @employer.subpath = params[:employer][:subpath].downcase
    if @employer.save
      flash[:notice] = t('resto.messages.account.subpath_updated', :subpath => @employer.subpath, :employer => @employer.business_name)
    else
      flash[:notice] = @employer.errors.full_messages
    end
    redirect_to(subpath_path(:subpath => @employer.subpath))
  end
  
  def index
    if me_employer? && !me_admin?
      redirect_to employer_path(current_user.profileable_id) and return
    end
    
    @search = Employer.search
    if me_admin?
      unless params[:name].blank?
        @search = @search.name_like(params[:name])
      end

      unless params[:state].blank?
        @search = @search.state_like(params[:state])
      end
    else
      params[:letter] = "A" unless params[:letter]

      # let SearchLogic sanitize input
      @search = if params[:letter] == "%23"
        @search.business_name_not_begin_with('A'..'Z')
      else
        @search.business_name_begins_with(params[:letter])
      end
    end
    
    # hide confidential employer
    unless me_admin?
      @search = @search.confidential_eq(false)
    end

    @employers = @search.paginate(:page => params[:page], :per_page => params[:per_page] || 10, :include => [:user])
    index!
  end
  
  def show
    if params[:subpath]
      @employer = Employer.user_active_eq(true).find_by_subpath(params[:subpath])
    else
      @employer = Employer.find(params[:id])
    end
    
    render_not_found_error and return unless @employer
    
    # only admin & owner if confidential
    if @employer.confidential == true
      if me_admin? || (current_user.employer? && (params[:id].to_i == current_user.profileable_id))
        true
      else
        render_not_found_error and return
      end
    end

    @jobs = Job.paginate_by_employer_id params[:id],
      :page => params[:page], 
      :include => [:job_applications]

    show!
  end

end
