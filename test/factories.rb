

Factory.define :admin do |f|
  f.name "Admin"
end

Factory.define :user, :class => User do |f|
  f.email "admin@demo.com"
  f.password "changeme"
  f.password_confirmation {|user| user.password }
  f.active true
  #f.profileable :admin
  #f.skip_session_maintenance true
end

Factory.define :user_admin, :parent => :user do |user|
  user.after_build { |u| Factory(:admin, :user => u) }
end


#Factory.define :green_curry, :class => Employer do |f|
#  f.bussiness_name "Green Curry Resto"
#  f.bussiness_type_id 1
#  f.city "Little Rock"
#  f.state "AR"
#  f.postal_code "12345"
#  f.confidential false
#  f.confirmed false
#end

#Factory.define :upscale, :class => Employer do |f|
#  f.bussiness_name "Upscale Dining"
#  f.bussiness_type_id 1
#  f.city "Hollywood"
#  f.state "CA"
#  f.postal_code "54321"
#  f.confidential true
#  f.confirmed false
#end


#Factory.define :inactive_employer_user do |f|

#end

