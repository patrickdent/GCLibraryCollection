require 'spec_helper'

describe "User Pages" do

  before do
    @user = create :user, name: "UserName"
    @librarian = create :librarian, name: "LibrarianName"
    @admin = create :admin, name: "AdminName" 
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
      it "doesn't have delete link" do expect(subject).to_not have_link("Delete") end
    end

    context "as admin" do

      before do
        admin_login 
        visit user_path(@user.id) 
      end

      it "displays user name" do expect(subject).to have_selector('h2', text: @user.name) end
      it "displays user email" do expect(subject).to have_content(@user.email) end
      it "has edit link" do expect(subject).to have_link("Edit This User") end
      it "has delete link" do expect(subject).to have_link("Delete") end
    end

    describe "my profile" do
      context "as librarian" do

        before do
          login_as(@librarian, scope: :user)
          visit user_path(@librarian.id)
        end

        it "displays user name" do expect(subject).to have_selector('h2', text: @librarian.name) end
        it "has edit login link" do expect(subject).to have_link("edit login information") end
      end

      context "as admin" do

        before do
          login_as(@admin, scope: :user)
          visit user_path(@admin.id)
        end

        it "displays user name" do expect(subject).to have_selector('h2', text: @admin.name) end
        it "has edit login link" do expect(subject).to have_link("edit login information") end
        it "doesn't have delete link" do expect(subject).to_not have_link("Delete") end
      end

      context "as patron" do

        before do
          login_as(@user, scope: :user)
          visit user_path(@user.id)
        end

        it "displays user name" do expect(subject).to have_selector('h2', text: @user.name) end
        it "has edit login link" do expect(subject).to have_link("edit login information") end
        it "doesn't flash error" do expect(subject).to_not have_content("You are not authorized") end
      end
    end
  end
end