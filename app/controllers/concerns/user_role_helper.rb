module UserRoleHelper

  #the following 2 methods should only be used in before filters
  def is_librarian?
    if current_user
      if current_user.has_role? :librarian
        return true
      elsif current_user.has_role? :admin
        return true
      else
        flash[:error] = "You are not authorized"
        redirect_to root_path
      end
    end
  end

  def is_admin?
    if current_user
      if current_user.has_role? :admin
        return true
      else
        flash[:error] = "You are not authorized"
        redirect_to root_path
      end
    end
  end

  def is_given_user_or_librarian?(user)
    if current_user
      if (current_user.has_role? :librarian) || (current_user.has_role? :admin) || (current_user == user) then
        return true
      else
        return false
      end
    end
  end
end