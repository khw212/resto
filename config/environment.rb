# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  # Translate Plugin requirements
  config.gem 'httparty'
  config.gem 'ya2yaml'

  # Authentication Support
  config.gem 'authlogic',
             :lib => 'authlogic',
             :version => '>= 2.1.1'
             
  # Pagination Support
  config.gem 'will_paginate',
             :lib => 'will_paginate',
             :version => '~> 2.3.11'
             
  # Forms Magic
  config.gem 'formtastic',
             :lib => 'formtastic',
             :version => '~> 0.9.7'
  
  # Attachment Support
  config.gem 'paperclip',
             :lib => 'paperclip',
             :version => '>= 2.3.0'
             
  # Lean Controller
  config.gem 'josevalim-inherited_resources', 
            :lib => 'inherited_resources', 
            :version => '~> 0.8.5',
            :source => 'http://gems.github.com'
            
  # Model Search
  config.gem 'searchlogic',
            :lib => 'searchlogic', 
            :version => '= 2.3.1'
            
  # Contact Form
  config.gem 'josevalim-simple_form', 
            :lib => 'simple_form', 
            :version => '~> 0.3.1',
            :source => 'http://gems.github.com'

  # Middleware Framework             
  config.gem 'rack',
             :version => '>= 1.0.0'

  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))

  config.time_zone = 'UTC'
  
  ## RESTO
  # set i18n to load subdirs also
  config.i18n.load_path += Dir[File.join(RAILS_ROOT, 'config', 'locales', '**', '*.{rb,yml}')] 
  # set recaptcha keys

  CAPTCHA_SALT = "somesalt"
  
  config.action_mailer.default_url_options = { :host => "job.casocial.com" }
  config.i18n.default_locale = 'zh-CN'
  config.gem 'exception_notification'
end

ExceptionNotification::Notifier.sender_address =  %("Exception (casocial.com)" <kw@casocial.com>)
ExceptionNotification::Notifier.exception_recipients = %w(kw@casocial.com)

