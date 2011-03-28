class ContactController < ApplicationController
  def show
  end

  def submit
    c = ContactForm.new(params[:contact])
    if captcha_validated?
      unless c.deliver
      flash[:notice] = c.errors.full_messages.join(", ")
      redirect_to :back and return
      end
    else
      flash[:notice] = t('resto.messages.flash.captcha_error')
      redirect_to :back and return
    end
  end

end
