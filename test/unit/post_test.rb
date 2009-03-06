require 'test_helper'

class PostTest < ActiveSupport::TestCase
  fixtures :topics, :posts
  # Replace this with your real tests.
  def test_required_body
    body = Post.create(:body => nil)
    assert body.errors.on(:body)
  end

  def test_topic_association
    assert_equal topics(:one), posts(:one).topic
  end
end
