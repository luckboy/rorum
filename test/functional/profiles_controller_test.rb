require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

#  def test_should_get_new
#    get :new
#    assert_response :success
#  end

#  def test_should_create_profile
#    assert_difference('Profile.count') do
#      post :create, :profile => { }
#    end
#
#    assert_redirected_to profile_path(assigns(:profile))
#  end

  def test_should_show_profile
    get :show, :id => profiles(:quentin).id
    assert_response :success
  end

  def test_should_get_edit
    login_as :quentin

    get :edit, :id => profiles(:quentin).id
    assert_response :success
  end

  def test_should_permission_denied_to_get_edit
    get :edit, :id => profiles(:quentin).id
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_update_profile
    login_as :quentin

    put :update, :id => profiles(:quentin).id, :profile => { }
    # assert_redirected_to profile_path(assigns(:profile))
    assert_redirected_to categories_path
  end
  
  def test_should_pemission_denied_to_update_profile
    put :update, :id => profiles(:quentin).id, :profile => { }
    assert_redirected_to categories_path
    assert_not_nil flash[:error]    
  end

#  def test_should_destroy_profile
#    assert_difference('Profile.count', -1) do
#      delete :destroy, :id => profiles(:one).id
#    end
#
#    assert_redirected_to profiles_path
#  end
end
