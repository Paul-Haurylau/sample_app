module ApplicationHelper
  def title
    base_url = 'Ruby on Rails Tutorial | '
    if @title.nil?
      return base_url
    else
      return base_url + @title
    end
  end
end
