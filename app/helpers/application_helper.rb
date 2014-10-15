module ApplicationHelper
  def fix_url(url)
    url.starts_with?('http://') ? url : 'http://' + url
  end

  def fix_time(time)
    time.localtime.strftime("(%d-%b-%Y %I:%M%p %Z)")
  end

  def link_based_on_current_users_vote_on_post(post_object, value)
    if Vote.find_by(creator: current_user, vote: value, voteable: post_object)
      link_to vote_destroy_post_path(post_object), method: 'delete', remote: true do
        "<i class='icon-fire'></i>".html_safe
      end
    else
      icon = value ? "<i class='icon-thumbs-up'></i>" : "<i class='icon-thumbs-down'></i>"
      link_to vote_post_path(post_object, vote: value), method: 'post', remote: true do
        icon.html_safe
      end
    end
  end

  def link_based_on_current_users_vote_on_comment(comment_object, value)
    if Vote.find_by(creator: current_user, vote: value, voteable: comment_object)
      link_to vote_destroy_post_comment_path(comment_object.post, comment_object), method: 'delete', remote: true do
        "<i class='icon-fire'></i>".html_safe
      end
    else
      icon = value ? "<i class='icon-thumbs-up'></i>" : "<i class='icon-thumbs-down'></i>"
      link_to vote_post_comment_path(comment_object.post, comment_object, vote: value), method: 'post', remote: true do
        icon.html_safe
      end
    end
  end

end
