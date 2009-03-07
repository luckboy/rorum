require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users, :topics, :forums

   def test_should_route_topics_of_forums
    options = {
      :controller => "topics",
      :action => "index",
      :forum_id => forums(:one).id.to_s
    }
    assert_routing "forums/#{forums(:one).id}/topics", options
  end

  def test_should_route_topic_of_forums
   options = {
      :controller => "topics",
      :action => "show",
      :forum_id => forums(:one).id.to_s,
      :id => topics(:one).id.to_s
    }
    assert_routing "forums/#{forums(:one).id}/topics/#{topics(:one).id}", options
  end

  def test_should_get_index
    get :index, :forum_id => forums(:one)
    assert_response :success
    assert_not_nil assigns(:topics)
  end

  def test_should_get_new
    login_as :aaron

    get :new, :forum_id => forums(:one).id
    assert_response :success
  end

  def test_should_permission_denied_to_get_new
    get :new, :forum_id => forums(:one).id
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_create_topic
    login_as :aaron

    assert_difference('Topic.count') do
      post :create, :forum_id => forums(:one).id, :topic => { :subject => "Next topic", :body => "bla bla bla"}
    end

    # assert_redirected_to topic_path(assigns(:topic))
    assert_redirected_to topic_posts_path(assigns(:topic))
  end

  def test_should_permission_denied_to_create_topic
    assert_no_difference('Topic.count') do
      post :create, :forum_id => forums(:one).id, :topic => { :subject => "Next topic", :body => "bla bla bla"}
    end

    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  # def test_should_show_topic
  #   get :show, :id => topics(:one).id
  #   assert_response :success
  # end

  def test_should_get_edit
    login_as :root

    get :edit, :forum_id => forums(:one).id, :id => topics(:one).id
    assert_response :success
  end

  def test_should_permission_denied_to_get_edit
    login_as :aaron

    get :edit, :forum_id => forums(:one).id, :id => topics(:one).id
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

  def test_should_update_topic
    login_as :root

    put :update, :forum_id => forums(:one).id, :id => topics(:one).id, :topic => { }
    # assert_redirected_to topic_path(assigns(:topic))
    assert_redirected_to topic_posts_path(assigns(:topic))
  end

  def test_should_permission_denied_to_update_topic
    login_as :aaron

    put :update, :forum_id => forums(:one).id, :id => topics(:one).id, :topic => { }
    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end


  def test_should_destroy_topic
    login_as :root

    assert_difference('Topic.count', -1) do
      delete :destroy, :forum_id => forums(:one), :id => topics(:one).id
    end

    assert_redirected_to forum_topics_path
  end

  def test_should_permission_denied_to_destroy_topic
    login_as :aaron

    assert_no_difference('Topic.count', -1) do
      delete :destroy, :forum_id => forums(:one), :id => topics(:one).id
    end

    assert_redirected_to categories_path
    assert_not_nil flash[:error]
  end

end
