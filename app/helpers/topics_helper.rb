module TopicsHelper
  def forum_path_links(forum)
    link_to("index", "/") + h(" >> #{forum.name}")
  end
end
