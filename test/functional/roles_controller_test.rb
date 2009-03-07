require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def setup
    login_as :root
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_role
    assert_difference('Role.count') do
      post :create, :role => { :name => "user2" }
    end

    # assert_redirected_to role_path(assigns(:role))
    assert_redirected_to roles_path
  end

  def test_should_show_role
    get :show, :id => roles(:user).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => roles(:user).id
    assert_response :success
  end

  def test_should_update_role
    put :update, :id => roles(:user).id, :role => { }
    # assert_redirected_to role_path(assigns(:role))
    assert_redirected_to roles_path
  end

  def test_should_destroy_role
    assert_difference('Role.count', -1) do
      delete :destroy, :id => roles(:user).id
    end

    assert_redirected_to roles_path
  end
end
