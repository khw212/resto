# abstract controller for business_type, education, job_categories & position_type
# all are the views are also the same (using inherited_resources)

class SimpleAdminDataController < ApplicationController

  # role lock.
  before_filter :require_user
  before_filter :require_admin

  # plugin:inherited_resources
  inherit_resources
  actions :all, :except => [:show]
  respond_to :html, :js, :json

  def update
    update! do |success, failure|
      success.html { redirect_to collection_url }
    end
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to collection_url }
    end
  end
  
end
