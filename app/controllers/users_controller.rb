class UsersController < ApplicationController
  # TODO: adjust so in case of admin user, can create/modify users..
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:show, :edit, :update, :toggle_active, :index]
  before_filter :find_user,       :only => [:show, :edit, :update, :toggle_active]
  before_filter :require_admin,   :only => [:toggle_active, :index]
  
  trap_door :only => :create
  
  def toggle_active
    @user.active = !@user.active
    if @user.save
      flash[:notice] = @user.active ? t('resto.messages.account.activated', :email => @user.email) : t('resto.messages.account.suspended', :email => @user.email)
    end
    redirect_back_or_default accounts_url
  end
  
  def index
    @search = User.search

    unless params[:profile].blank?
      @search.profileable_type_like(params[:profile].classify)
    end
    @users = @search.paginate(:page => params[:page], :per_page => params[:per_page] || 10)
  end
  
  def new
    #variable to display captcha on registration
    @new_user = true
    # valid profile creation?
    unless me_admin?
      unless %w(job_seeker employer).include?(params[:id])
        render_not_found_error and return
      end
    end
    unless params[:id]
      render_not_found_error and return
    end
    @user = User.new
    @user.build_profileable({ :profileable_attributes => { :profileable_type => params[:id].classify } }) 
  end
  
  def create
    profile = params[:user].slice(:profileable_attributes)
    # only admin can create accounts other than employer & job seeker
    unless me_admin?
      unless %w(JobSeeker Employer).include?(profile[:profileable_attributes][:profileable_type])
        render_not_found_error and return
      end
    end
    
    account = params[:user].except(:profileable_attributes)
    @user   = User.new(account)
    @user.build_profileable(profile)
    
    # admin can create accounts without logging_in
    if me_admin?
      if @user.profileable_type == 'Employer'
        @user.profileable.subpath = @user.login
      end
      if @user.save_without_session_maintenance
        flash[:notice] = t('resto.messages.account.registered')
        redirect_to accounts_url and return
      else
        params[:id] = params[:user][:profileable_attributes][:profileable_type].underscore
        render :action => :new and return
      end
    # regular user must verify captcha
    else
      #variable to display captcha on registration
      @new_user = true
      
      if captcha_validated?
        if @user.profileable_type == 'Employer'
          #@user.active = false
          @user.active = true
          @user.profileable.subpath = @user.login
          #if @user.save_without_session_maintenance
          if @user.save
            #flash[:notice] = t('resto.messages.account.employer_registered')
            #Mailer.deliver_employer_register(:body => { :email => @user.email })
            #redirect_to root_url and return
            flash[:notice] = t('resto.messages.account.registered')
            redirect_to welcome_url and return
          else
            flash[:notice] = t('resto.messages.flash.form_error')
            params[:id] = params[:user][:profileable_attributes][:profileable_type].underscore
            render :action => :new and return
          end
        else
          if @user.save
            flash[:notice] = t('resto.messages.account.registered')
            redirect_to welcome_url and return
          else
            flash[:notice] = t('resto.messages.flash.form_error')
            params[:id] = params[:user][:profileable_attributes][:profileable_type].underscore
            render :action => :new and return
          end
        end
      else
	      flash[:notice] = t('resto.messages.flash.captcha_error')
        params[:id] = params[:user][:profileable_attributes][:profileable_type].underscore
        render :action => :new and return
      end
    end
  end
  
  def show
  end

  def edit
    session[:return_to] = params[:return_to]
  end
  
  def update
    profile = params[:user].slice(:profileable_attributes)
    account = params[:user].except(:profileable_attributes)
      
    @user.build_profileable(profile)
    
    if @user.update_attributes(account)
      flash[:notice] = t('resto.messages.account.updated')
      if me_admin?
        redirect_back_or_default(welcome_url)
      else  
        redirect_back_or_default(welcome_url)
      end
    else
      flash[:notice] = t('resto.messages.flash.form_error')
      render :action => :edit
    end
  end
  
  private
    def find_user
      if me_admin?
        @user = params[:id] ? User.find(params[:id]) : @current_user
      else
        @user = @current_user
      end
    end
    
    def ensure_profile
      if current_user
        @profile = @user.profileable_type.underscore
      # safely assume that this is a registration process
      else
        @profile = params[:id]      
      end
      render :partial => "users/form_#{ partial_name }"
    end
end
