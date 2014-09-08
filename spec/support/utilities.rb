
def admin_login
  visit root_path
  click_on('Login')
  fill_in("Email", :with => 'admin@example.com')
  fill_in("Password", :with => 'password')
  click_on("Sign in")
end
