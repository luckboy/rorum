module PostsHelper
  def topic_path_links(topic)
    link_to("index", "/") + h(" >> ") + link_to(topic.forum.name, forum_topics_path(@topic.forum)) + h(" >> #{topic.subject}")
  end
end
