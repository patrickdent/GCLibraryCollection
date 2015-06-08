module UsersHelper

  def librarian_user?
    if current_user
      if current_user.has_role? :librarian
        return true
      elsif current_user.has_role? :admin
        return true
      end
    end
    return false
  end


  def admin_user?
    if current_user
      if current_user.has_role? :admin
        return true
      end
    end
    return false
  end

end
