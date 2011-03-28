class ContactForm < SimpleForm
  subject "Resto Contact Form"
  recipients "cs@casocial.com"

  attribute :name,      :validate => true
  attribute :email,     :validate => /[^@]+@[^\.]+\.[\w\.\-]+/
  attribute :message,   :validate => true
  attribute :website,   :captcha  => true
end

