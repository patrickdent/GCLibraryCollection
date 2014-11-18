module Logins

  def login_admin
    @admin = FactoryGirl.create(:admin)
    post_via_redirect user_session_path, 'user[email]' => @admin.email, 'user[password]' => @admin.password
  end

  def login_librarian
    @admin = FactoryGirl.create(:librarian)
    post_via_redirect user_session_path, 'user[email]' => @librarian.email, 'user[password]' => @librarian.password
  end

  def login_user
    @user = FactoryGirl.create(:user)
    post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
  end

end