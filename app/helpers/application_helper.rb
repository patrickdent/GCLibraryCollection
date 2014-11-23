module ApplicationHelper

def location
  location = params[:controller].humanize.downcase
  case location
    when 'static pages'
      'library'
    when 'devise/sessions'
      'login'
    when 'search'
      if request.original_url.include?('/import') then
        'import'
      else
        location
      end
    else
      location
  end
end

end