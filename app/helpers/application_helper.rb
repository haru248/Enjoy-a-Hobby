module ApplicationHelper
  def page_title(title = '')
    default_title = 'LIVE Pl@nning'
    title.empty? ? default_title : "#{title} | #{default_title}"
  end
end
