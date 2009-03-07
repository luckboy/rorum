require 'test_helper'

class ForumsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users, :forums, :categories

  # def test_should_get_index
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:forums)
  # end

  def test_should_route_forums_of_categories
    options = {
      :controller => "forums",
      :action => "index",
      :category_id => categories(:one).id.to_s
    }
    assert_routing "categories/#{categories(:one).id}/forums", options
  end
  
  def test_should_route_forum_of_categories
   options = {
      :controller => "forums",
      :action => "show",
      :category_id => categories(:one).id.to_s,
      :id => forums(:one).id.to_s
    }
    assert_routing "categories/#{categories(:one).id}/forums/#{forums(:one).id}", options
  end

  def test_should_get_new
    login_as :root

    get :new, :category_id => categories(:one).id
    assert_response :success
  end

  def test_should_permission_denied_to_get_new
    get :new, :category_id => categories(:one).id
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_not_found_new
    get :new
    assert_response :not_found
  end

  def test_should_create_forum
    login_as :root

    assert_difference('Forum.count') do
      post :create, :category_id => categories(:one).id, :forum => { :name => 'Next forum', :description => 'bla bla bla.' }
    end

    # assert_redirected_to forum_path(assigns(:forum))
    assert_redirected_to categories_path
  end

  def test_should_permission_denied_to_create_forum
    assert_no_difference('Forum.count') do
      post :create, :category_id => categories(:one).id, :forum => { :name => 'Next forum', :description => 'bla bla bla.' }
    end

    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_not_found_create_forum
    assert_no_difference('Forum.count') do
      post :create, :forum => { :name => 'Next forum', :description => 'bla bla bla.' }
    end

    assert_response :not_found
  end

  # def test_should_show_forum
  #   get :show, :id => forums(:one).id
  #   assert_response :success
  # end

  def test_should_get_edit
    login_as :root

    get :edit, :category_id => categories(:one).id, :id => forums(:one).id
    assert_response :success
  end

  def test_should_permission_denied_to_get_edit
    get :edit, :category_id => categories(:one).id, :id => forums(:one).id
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_not_found_get_edit
    get :edit, :id => forums(:one).id
    assert_response :not_found
  end

  def test_should_update_forum
    login_as :root

    put :update, :category_id => categories(:one).id, :id => forums(:one).id, :forum => { }
    # assert_redirected_to forum_path(assigns(:forum))
    assert_redirected_to categories_path
  end

  def test_should_permission_denied_update_forum
    put :update, :category_id => categories(:one).id, :id => forums(:one).id, :forum => { }
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_not_found_update_forum
    put :update, :id => forums(:one).id, :forum => { }
    assert_response :not_found
  end

  def test_should_destroy_forum
    login_as :root

    assert_difference('Forum.count', -1) do
      delete :destroy, :category_id => categories(:one).id, :id => forums(:one).id
    end

    # assert_redirected_to forums_path
    assert_redirected_to categories_path
  end

  def test_should_permission_denied_to_destroy_forum
    assert_no_difference('Forum.count', -1) do
      delete :destroy, :category_id => categories(:one).id, :id => forums(:one).id
    end

    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_not_found_destroy_forum
    assert_no_difference('Forum.count', -1) do
      delete :destroy, :id => forums(:one).id
    end

    assert_response :not_found
  end
end
