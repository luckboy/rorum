require 'test_helper'

class SearchOutputsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_search_output
    post :create, :keywords => "MyText1", :author => "aaron", :forum => "", :search_in => "1"
    assert_redirected_to search_output_topics_path
  end
end
