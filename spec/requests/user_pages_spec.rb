require 'spec_helper'

describe "User Pages" do

  before do
    @user = create :user
    @librarian = create :librarian
    @admin = create :admin 
  end

  subject { page }

  describe "index" do
    context "as librarian" do
      before do
        librarian_login
        visit users_path
      end

      it "links to users" do expect(subject).to have_link(@user.name, user_path(@user.id)) end
      it "has edit link" do expect(subject).to have_link("Edit") end
    end

    context "as admin" do
      before do
        admin_login
        visit users_path
      end

      it "links to users" do expect(subject).to have_link(@user.name, user_path(@user.id)) end
      it "has edit link" do expect(subject).to have_link("Edit") end
      it "has delete link" do expect(subject).to have_link("Delete") end
    end
  end

  describe "show" do

    context "as librarian" do

      before do
        librarian_login 
        visit user_path(@user.id) 
      end

      it "displays user name" do expect(subject).to have_selector('h2', text: @user.name) end
      it "displays user email" do expect(subject).to have_content(@user.email) end
      it "has edit link" do expect(subject).to have_link("Edit This User") end
    end
  end
end