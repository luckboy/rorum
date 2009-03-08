require 'test_helper'

class RoleListsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  fixtures :users

  # Replace this with your real tests.
  def test_should_get_edit
    login_as :root
    get :edit, :id => users(:aaron).id
    assert_response :success
  end

  def test_should_permission_denied_to_get_edit
    get :edit, :id => users(:aaron).id
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_update_role_list
    login_as :root
    put :update,  :id => users(:aaron).id, :user => { }
    assert_redirected_to profiles_path
  end

  def test_should_permission_denied_to_update_role_list
    put :update,  :id => users(:aaron).id, :user => { }
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end
end
