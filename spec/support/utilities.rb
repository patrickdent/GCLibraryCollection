def admin_login
  admin = FactoryGirl.create(:admin)
  login_as(admin, scope: :user)
end

