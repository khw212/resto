class Mailer < ActionMailer::Base

  helper ActionView::Helpers::UrlHelper

  def generic_mailer(options)

    @recipients = options[:recipients]
    @from = options[:from]

    @cc = options[:cc] || ""
    @bcc = options[:bcc] || ""

    @subject = options[:subject] || ""
    @body = options[:body] || {}

    @headers = options[:headers] || {}
    @charset = options[:charset] || "utf-8"

  end

  def employer_register(options)
    options[:recipients] = 'cs@casocial.com'
    options[:subject]    = '[Resto] Pending Registration'
    self.generic_mailer(options)
  end
  
  def employer_approved(options)
    options[:subject]    = 'Account approved'
    self.generic_mailer(options)
  end
  
  def employer_declined(options)
    options[:subject]    = 'Account declined'
    self.generic_mailer(options)
  end
  
end
