# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_post(post)
    unless post.nil?
      "#{link_to((h(post.created_at.to_formatted_s :short)), [post.topic, post])} #{by_user post.author}"
    else
      _("No post")
    end
  end

  def by_user(user)
    _("by")+" #{h(user.login)}"
  end

  def role_list(roles)
    h(roles.collect { |role| role.name }.join ", ")
  end

  def forum_list(forums)
    forums.collect { |forum| h forum.name }.join tag(:br)
  end

  def body_format(text)
    text = text.to_s.dup
    text.gsub!(/(\r\n)|\n/, (tag :br))
    # content_tag :p, text
    text
  end
end
