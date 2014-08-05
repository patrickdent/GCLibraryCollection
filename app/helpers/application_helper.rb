module ApplicationHelper

  def is_admin? 
    if current_user.has_role? :admin
      return true 
    else
      flash[:error] = "You are not authorized"
      redirect_to root_path
    end 
  end 
end
