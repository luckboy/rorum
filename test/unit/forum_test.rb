require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  fixtures :categories, :forums, :topics

  # Replace this with your real tests.
  def test_required_name
    forum = Forum.create(:name => nil)
    assert forum.errors.on(:name)
  end

  def test_required_description
    forum = Forum.create(:description => nil)
    assert forum.errors.on(:description)
  end

  def test_create_forum
    forum = Forum.create(:name => "New forum", :description => "Bla bla bla :).")
    assert !forum.new_record?
  end

  def test_category_association
    assert_equal categories(:one), forums(:one).category
  end

  def test_topics_association
    topics1 = [topics(:one), topics(:two)].sort { |x, y| x.id <=> y.id }
    topics2 = forums(:one).topics.sort { |x, y| x.id <=> y.id }
    assert_equal topics1, topics2
  end

  def test_paginate_topics_sorted
    topics1 = [topics(:five), topics(:four), topics(:three)]
    topics2 = forums(:two).paginate_topics_sorted(3, 1).to_a
    assert_equal topics1, topics2
  end

  def test_empty_paginate_topics_sorted
    topics =  forums(:empty).paginate_topics_sorted(3, 1).to_a
    assert_equal topics, []
  end

  def test_first_page_topics_sorted
    topics1 = [topics(:five), topics(:four)]
    topics2 = forums(:two).paginate_topics_sorted(2, 1).to_a
    assert_equal topics1, topics2
  end

  def test_second_page_topics_sorted
    topics1 = [topics(:three)]
    topics2 = forums(:two).paginate_topics_sorted(2, 2).to_a
    assert_equal topics1, topics2
  end

  def test_posts_count
    assert_equal forums(:one).posts_count, 3
    assert_equal forums(:two).posts_count, 6
  end

  def test_last_post
    assert_equal forums(:two).last_post, posts(:six)
  end

end
