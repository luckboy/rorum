require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  fixtures :forums, :topics, :posts

  # Replace this with your real tests.
  def test_required_subject
    topic = Topic.create(:subject => nil)
    assert topic.errors.on(:subject)
  end

  def test_no_required_body
    topic = Topic.create(:body => nil)
    assert !topic.errors.on(:body)
  end

  def test_create_topic
    topic = Topic.create(:subject => "New topic")
    assert !topic.new_record?
    assert_equal topic.posts.count, 0
  end

  def test_create_topic_and_post
    topic = Topic.create(:subject => "New topic", :body => "Bla bla bla:).")
    assert !topic.new_record?
    assert_equal topic.posts.count, 1
  end

  def test_forum_association
    assert_equal forums(:one), topics(:one).forum
  end

  def test_posts_association
    posts1 = [posts(:one), posts(:two)].sort { |x, y| x.id <=> y.id }
    posts2 = topics(:one).posts.sort { |x, y|  x.id <=> y.id }
    assert_equal posts1, posts2
  end

  def test_paginate_posts_sorted
    posts1 = [posts(:four), posts(:seven), posts(:eight)]
    posts2 = topics(:four).paginate_posts_sorted(3, 1).to_a
    assert_equal posts1, posts2
  end

  def test_empty_paginate_posts_sorted
    posts = topics(:empty).paginate_posts_sorted(3, 1).to_a
    assert_equal posts, []
  end

  def test_first_page_posts_sorted
    posts1 = [posts(:four), posts(:seven)]
    posts2 = topics(:four).paginate_posts_sorted(2, 1).to_a
    assert_equal posts1, posts2
  end

  def test_second_page_posts_sorted
    posts1 = [posts(:eight)]
    posts2 = topics(:four).paginate_posts_sorted(2, 2).to_a
    assert_equal posts1, posts2
  end

  def test_last_post
    assert_equal topics(:five).last_post, posts(:six)
    assert_equal topics(:four).last_post, posts(:eight)
  end

  def test_replies_count
    assert_equal topics(:five).replies_count, 1
    assert_equal topics(:four).replies_count, 2
  end

  def test_page_with_post
    assert_equal topics(:four).page_with_post(2, posts(:four)), 1
    assert_equal topics(:four).page_with_post(2, posts(:seven)), 1
    assert_equal topics(:four).page_with_post(2, posts(:eight)), 2
  end

  def test_join_conditions
    conditions = ["(number + ? = ?) AND (second_number = ?)", 5, 2, 3]
    assert_equal Topic.join_conditions([["number + ? = ?", 5, 2], ["second_number = ?", 3]]), conditions
  end

  def test_join_conditions_for_operator_or
    conditions = ["(text || ? = ?) OR (number = ?)", "bla", "bla bla bla", 10]
    assert_equal Topic.join_conditions([["text || ? = ?", "bla", "bla bla bla"], ["number = ?", 10]], "OR"), conditions
  end

  def test_join_conditions_for_nil_elements
    conditions = ["(x = ?) AND (y = ?)", 3, 4]
    assert_equal Topic.join_conditions([nil, ["x = ?", 3], nil, ["y = ?", 4], nil]), conditions
  end

  def test_like_escape_for_backslash
    assert_equal Topic.like_escape("path\\windows\\directory"), "path\\\\windows\\\\directory"
  end

  def test_like_escape_for_percentag
    assert_equal Topic.like_escape("100% or 50%"), "100\\% or 50\\%"
  end

  def test_like_escape_for_underlining
    assert_equal Topic.like_escape("create_user"), "create\\_user"
  end

  def test_conditions_for_author
    conditions = ["posts.author_id = ?", users(:aaron).id]
    assert_equal Topic.conditions_for_author("posts", users(:aaron)), conditions
  end

  def test_conditions_for_keywords_for_posts
    conditions = ["(UPPER(posts.body) LIKE ?) OR (UPPER(posts.body) LIKE ?) OR (UPPER(posts.body) LIKE ?) OR (UPPER(posts.body) LIKE ?)", "%RUBY%", "%RAILS%", "%LINUX%", "%100\\%%"]
    assert_equal Topic.conditions_for_keywords("posts", %w{ruby rails linux 100%}), conditions
  end

  def test_conditions_for_keywords_for_topics
    conditions = ["(UPPER(topics.subject) LIKE ?) OR (UPPER(topics.subject) LIKE ?) OR (UPPER(topics.subject) LIKE ?) OR (UPPER(topics.subject) LIKE ?)", "%RUBY%", "%RAILS%", "%LINUX%", "%100\\%%"]
    assert_equal Topic.conditions_for_keywords("topics", %w{ruby rails linux 100%}), conditions
  end

  def test_conditions_for_keywords_for_posts_and_with_author
    conditions = ["((UPPER(posts.body) LIKE ?) OR (UPPER(posts.body) LIKE ?)) AND (posts.author_id = ?)", "%LINUX%", "%WINDOWS%", users(:quentin).id]
    assert_equal Topic.conditions_for_keywords("posts", %w{linux windows}, users(:quentin)), conditions
  end

  def test_conditions_for_keywords_for_topics_and_with_author
    conditions = ["((UPPER(topics.subject) LIKE ?) OR (UPPER(topics.subject) LIKE ?)) AND (topics.author_id = ?)", "%LINUX%", "%WINDOWS%", users(:quentin).id]
    assert_equal Topic.conditions_for_keywords("topics", %w{linux windows}, users(:quentin)), conditions
  end

  def test_conditions_for_keywords_for_posts_and_without_keywords
    conditions = ["posts.author_id = ?", users(:aaron).id]
    assert_equal Topic.conditions_for_keywords("posts", [], users(:aaron)), conditions
  end

  def test_conditions_for_keywords_for_topics_and_without_keywords
    conditions = ["topics.author_id = ?", users(:aaron).id]
    assert_equal Topic.conditions_for_keywords("topics", [], users(:aaron)), conditions
  end

  def test_paginate_search_topics
    params = {
      :keywords =>  "MyText1 'OS'",
      :author => nil,
      :forum => nil,
      :search_in => "1" # posty i watki
    }
    topics1 = [topics(:three), topics(:one)]
    topics2 = Topic.paginate_search_topics(3, 1, params).to_a
    assert_equal topics1, topics2
  end

  def test_paginate_search_topics_in_forum
    params = {
      :keywords => "'SO'",
      :author => nil,
      :forum => forums(:two).id,
      :search_in => "2" # tylko posty
    }
    topics1 = [topics(:three)]
    topics2 = Topic.paginate_search_topics(3, 1, params).to_a
    assert_equal topics1, topics2
  end

  def test_paginate_search_topics_for_author
    params = {
      :keywords => "super",
      :author => "aaron",
      :forum => nil,
      :search_in => "3" # tylko watki
    }
    topics1 = [topics(:one)]
    topics2 = Topic.paginate_search_topics(3, 1, params).to_a
    assert_equal topics1, topics2
  end

  def test_paginate_search_topics_without_keywords
    params = {
      :keywords => nil,
      :author => "root",
      :forum => nil,
      :search_in => "1" # posty i watki
    }
    topics1 = [topics(:two)]
    topics2 = Topic.paginate_search_topics(3, 1, params).to_a
    assert_equal topics1, topics2
  end

  def test_paginate_search_topics_for_author_and_in_forum
     params = {
      :keywords => "post",
      :author => "root",
      :forum => forums(:one).id,
      :search_in => "1" # posty i watki
    }
    topics1 = [topics(:two)]
    topics2 = Topic.paginate_search_topics(3, 1, params).to_a
    assert_equal topics1, topics2
  end

  def test_required_keywords_and_author_in_search_topics
    params = {
      :keywords => nil,
      :author => nil,
      :forum => nil,
      :search_in => "1" # posty in watki
    }
    assert_nil Topic.paginate_search_topics(3, 1, params)
  end

end
