# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.debug_rjs                         = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

config.action_mailer.delivery_method = :smtp
config.action_mailer.perform_deliveries = true
config.action_mailer.smtp_settings = {
    :enable_starttls_auto => true,
    :address        => 'smtp.gmail.com',
    :port           => 587,
    :domain         => 'domain.com',
    :authentication => :plain,
    :user_name      => 'noreply@domain.com',
    :password       => 'password'
}

HOST = 'localhost'

config.gem "rails-footnotes"
config.gem "inaction_mailer", :lib => 'inaction_mailer/force_load'


#config.gem 'flyerhzm-bullet', :lib => 'bullet', :source => 'http://gems.github.com'
#config.after_initialize do
#  Bullet.growl = false
#  Bullet.enable = true 
#  Bullet.alert = true
#  Bullet.bullet_logger = true  
#  Bullet.console = true
#  Bullet.rails_logger = true
#  Bullet.disable_browser_cache = true
#end

