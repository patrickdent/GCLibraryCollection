def admin_login
  admin = FactoryGirl.create(:admin)
  login_as(admin, scope: :user)
end

def librarian_login
  lib = create :librarian
  login_as(lib, scope: :user)
end

