module UsersHelper

  def user_params
    params.require(:user).permit( :email, :password, :password_confirmation, :remember_me, 
                                  :notes, :name, :phone, :sort_by, :do_not_lend, :address, 
                                  :identification )
  end

  def librarian_user? 
    if current_user
      if current_user.has_role? :librarian
        return true
      elsif current_user.has_role? :admin
        return true        
      end
    end
    false
  end 


  def admin_user? 
    if current_user
      if current_user.has_role? :admin
        return true
      end
    end
    false
  end

end
