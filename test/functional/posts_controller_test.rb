require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users, :posts, :topics

  def test_should_route_posts_of_topics
    options = {
      :controller => "posts",
      :action => "index",
      :topic_id => topics(:one).id.to_s
    }
    assert_routing "topics/#{topics(:one).id}/posts", options
  end

  def test_should_route_post_of_topics
   options = {
      :controller => "posts",
      :action => "show",
      :topic_id => topics(:one).id.to_s,
      :id => posts(:one).id.to_s
    }
    assert_routing "topics/#{topics(:one).id}/posts/#{posts(:one).id}", options
  end

  def test_should_get_index
    get :index, :topic_id => topics(:one).id
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  def test_should_not_found_get_index
    get :index
    assert_response :not_found
  end

#  def test_should_get_new
#    get :new
#    assert_response :success
#  end

  def test_should_create_post
    login_as :aaron

    assert_difference('Post.count') do
      post :create, :topic_id => topics(:one).id, :post => { :body => "bla bla bla bla" }
    end

    # assert_redirected_to post_path(assigns(:post))
    assert_redirected_to topic_posts_path(assigns(:topic))
  end

  def test_should_permission_denied_to_create_post
    assert_no_difference('Post.count') do
      post :create, :topic_id => topics(:one).id, :post => { :body => "bla bla bla bla" }
    end
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_not_found_create_post
    assert_no_difference('Post.count') do
      post :create, :post => { :body => "bla bla bla bla" }
    end

    assert_response :not_found
  end

  def test_should_show_post
    get :show, :topic_id => topics(:one).id, :id => posts(:one).id
    assert_response :redirect
  end

  def test_should_not_found_show_post
    get :show, :id => posts(:one).id
    assert_response :not_found
  end

  def test_should_get_edit
    login_as :root

    get :edit, :topic_id => topics(:one).id, :id => posts(:one).id
    assert_response :success
  end

  def test_should_permission_denied_to_get_edit
    login_as :aaron

    get :edit, :topic_id => topics(:one).id, :id => posts(:one).id
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_not_found_get_edit
    get :edit, :id => posts(:one).id
    assert_response :not_found
  end

  def test_should_update_post
    login_as :root

    put :update, :topic_id => topics(:one).id, :id => posts(:one).id, :post => { }
    # assert_redirected_to post_path(assigns(:post))
    assert_redirected_to topic_posts_path(assigns(:topic))
  end

  def test_should_pemission_denied_to_update_post
    login_as :aaron

    put :update, :topic_id => topics(:one).id, :id => posts(:one).id, :post => { }
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_not_found_update_post
    put :update, :topic_id => topics(:one).id, :id => posts(:one).id, :post => { }
    assert_response :not_found
  end

  def test_should_destroy_post
    login_as :root

    assert_difference('Post.count', -1) do
      delete :destroy, :topic_id => topics(:one).id, :id => posts(:one).id
    end

    # assert_redirected_to posts_path
    assert_redirected_to topic_posts_path(assigns(:topic))
  end

  def test_should_pemission_denied_to_destroy_post
    login_as :aaron

    assert_no_difference('Post.count', -1) do
      delete :destroy, :topic_id => topics(:one).id, :id => posts(:one).id
    end

    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_not_found_destroy_post
    assert_no_difference('Post.count', -1) do
      delete :destroy, :id => posts(:one).id
    end

    assert_response :not_found
  end
end
