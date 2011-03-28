a = Admin.new "Super User"
u = User.new :email => "admin@admin.com", :password => "nimda", :password_confirmation => "nimda"
u.profileable = a
u.save
