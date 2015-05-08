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

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {sort: column, direction: direction, page: nil}, {:class => css_class}
  end
end