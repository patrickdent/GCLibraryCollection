
def admin_login
  admin = FactoryGirl.create(:admin, password: "password", email: "email@email.com")
  visit root_path
  click_on('Login')
  fill_in("Email", :with => admin.email)
  fill_in("Password", :with => 'password')
  click_on("Sign in")
end
