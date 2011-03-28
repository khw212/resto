require 'authlogic'

class ApplicationController < ActionController::Base
  include ExceptionNotification::Notifiable
  include SafetyValve::ApplicationController  
  include ValidatesCaptcha::InstanceMethods
  helper CaptchaHelper

  helper :all
  protect_from_forgery

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  helper_method :my_resume?, 
    :my_job?, 
    :my_profile?, 
    :me_admin?, 
    :me_employer?, 
    :me_moderator?, 
    :me_job_seeker?
      
  #plugin: translate-routes
  before_filter :set_locale_from_url
  
  # this filter must be placed after locale is set.
  before_filter :set_will_paginate_locale


  private
    # setup pagination display
    def set_will_paginate_locale
      WillPaginate::ViewHelpers.pagination_options[:previous_label] = t('resto.pagination.previous')
      WillPaginate::ViewHelpers.pagination_options[:next_label]     = t('resto.pagination.next')
    end


    # helper methods for administration actions
    def my_profile?(account_id)
      return false unless current_user
      return true if current_user.admin?
      return (current_user.id == account_id)
    end
    
    def my_resume?(resume)
      return false unless current_user
      return true if current_user.admin?
      return (current_user.job_seeker? && current_user.profileable == resume.job_seeker)
    end
    
    def my_job?(job)
      return false unless current_user
      return true if current_user.moderator?
      return true if current_user.admin?
      return (current_user.employer? && current_user.profileable == job.employer)
    end

    def me_admin?
      return false unless current_user
      return current_user.admin?
    end
    
    def me_moderator?
      return false unless current_user
      return current_user.moderator?
    end
    
    def me_employer?
      return false unless current_user
      return (current_user.admin? || current_user.employer? || current_user.moderator?)
    end
    
    def me_job_seeker?
      return false unless current_user
      return (current_user.admin? || current_user.job_seeker? || current_user.moderator?)
    end
        
    # roles, admin as super_user 
    def require_employer
      return false unless current_user
      unless current_user.employer? || current_user.admin? || current_user.moderator?
        render_error(401) and return false
      end
    end
    
    def require_job_seeker
      return false unless current_user
      unless current_user.job_seeker? || current_user.admin?
        render_error(401) and return false
      end
    end
    
    def require_admin
      return false unless current_user
      unless current_user.admin?
        render_error(401) and return false
      end
    end


    # from AuthLogic
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = t('resto.messages.flash.must_login')
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user && !current_user.admin?
        store_location
        flash[:notice] = t('resto.messages.flash.must_logout')
        redirect_to root_url#account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
end

