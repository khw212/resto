require 'test_helper'
require 'pp'

class EmployersControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  context "Logged in as Admin" do
    setup do
      @current_user = Factory(:user_admin)
      @current_user_session = UserSession.create(:email => 'admin@demo.com', :password => 'changeme')
      pp @current_user
      pp @current_user_session
      get :index
    end
      should_assign_to :current_user
      should_assign_to :employers
      should_render_template :pending
      should_not_set_the_flash
  end
  
#  context "As Admin" do
#    #setup { @current_user = UserSession.create(Factory(:admin_user)) }
#    

#      
#      should_render_template :pending
#      #should_not_set_the_flash
#      #should_assign_to(:current_user).with(@current_user)
#      should_assign_to :employers
#      #@current_user.admin?.should == true
#    end
#    
##    context "on GET to /pending" do
##      setup { get :pending }
##      should_render_template :pending
##      #should_not_set_the_flash
##      should_assign_to :current_user, :employers
##      #assert_equal 'current_user.admin?', true

##      should "list all inactive employers" do
##        assert_select "#employers"do
##          assert_select ".employer:first"
##        end
##      end
##    end
#    
#  end
#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:employers)
#  end

#  test "should get new" do
#    get :new
#    assert_response :success
#  end

#  test "should create employer" do
#    assert_difference('Employer.count') do
#      post :create, :employer => { }
#    end

#    assert_redirected_to employer_path(assigns(:employer))
#  end

#  test "should show employer" do
#    get :show, :id => employers(:one).id
#    assert_response :success
#  end

#  test "should get edit" do
#    get :edit, :id => employers(:one).id
#    assert_response :success
#  end

#  test "should update employer" do
#    put :update, :id => employers(:one).id, :employer => { }
#    assert_redirected_to employer_path(assigns(:employer))
#  end

#  test "should destroy employer" do
#    assert_difference('Employer.count', -1) do
#      delete :destroy, :id => employers(:one).id
#    end

#    assert_redirected_to employers_path
#  end
end
