class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:destroy]
  
  def new
    session[:return_to] = params[:return_to] if params[:return_to]
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if captcha_validated?
      if @user_session.save
        flash[:notice] = t('resto.messages.account.logged_in')
        redirect_back_or_default welcome_url
      else
        flash[:notice] = @user_session.errors.full_messages
        redirect_to :back
      end
    else
      flash[:notice] = t('resto.messages.flash.captcha_error')
      redirect_to :back
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = t('resto.messages.account.logged_out')
    redirect_to login_url
  end
end
