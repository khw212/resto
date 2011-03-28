class Moderator < ActiveRecord::Base
  has_one :user, :as => :profileable
end
