require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  fixtures :users

  # def setup
  #  # @controller = SessionsController.new
  #  @request    = ActionController::TestRequest.new
  #  @response   = ActionController::TestResponse.new
  # end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  def test_should_get_new
    login_as :root

    get :new
    assert_response :success
  end

  def test_should_create_category
    login_as :root

    assert_difference('Category.count') do
      post :create, :category => { :name => 'Next category' }
    end

    # assert_redirected_to category_path(assigns(:category))
    assert_redirected_to categories_path
  end

  # def test_should_show_category
  #   get :show, :id => categories(:one).id
  #   assert_response :success
  # end

  def test_should_get_edit
    login_as :root

    get :edit, :id => categories(:one).id
    assert_response :success
  end

  def test_should_update_category
    login_as :root

    put :update, :id => categories(:one).id, :category => { }
    # assert_redirected_to category_path(assigns(:category))
    assert_redirected_to categories_path
  end

  def test_should_destroy_category
    login_as :root
    
    assert_difference('Category.count', -1) do
      delete :destroy, :id => categories(:one).id
    end

    assert_redirected_to categories_path
  end

end
