require 'spec_helper'

describe StaticPagesController do 
  


  it "should have a current_user" do
    login_user
    visit root_path 
    page { should have_content(user.email) }
  end

  it "should show admin links to admins" do
    login_admin
    visit root_path 
    page { should have_selector('a', text: 'admin dashboard') }
  end

  it "should not show admin links to non-admins" do
    login_user
    visit root_path 
    page { should_not have_selector('a', text: 'admin dashboard') }
  end

end 
