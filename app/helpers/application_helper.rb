module ApplicationHelper
  def fix_url(url)
    url.starts_with?('http://') ? url : 'http://' + url
  end

  def fix_time(time)
    time.localtime.strftime("(%d-%b-%Y %I:%M%p %z)")
  end
end
