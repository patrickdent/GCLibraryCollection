require 'spec_helper'

describe UsersController do

  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  before :each do
    Warden.test_reset!
  end

  describe 'as a visitor' do
    it 'all actions require authentication' do
      @user = create :user

      expect(get :index).to redirect_to(new_user_session_path)
      expect(get :edit, id: @user.id).to redirect_to(new_user_session_path)
      expect(post :update, id: @user.id).to redirect_to(new_user_session_path)
      expect(delete :destroy, id: @user.id).to redirect_to(new_user_session_path)
      expect(get :show, id: @user.id).to redirect_to(new_user_session_path)
      expect(post :send_reminders).to redirect_to(new_user_session_path)
    end
  end

  describe 'as a patron' do
    it 'does not allow patrons to do anything with users' do
      @user = create :user
      @librarian = create :librarian
      patron = create :user
      sign_in patron

      expect(get :index).to redirect_to(root_path)
      expect(get :edit, id: @user.id).to redirect_to(root_path)
      expect(post :update, id: @user.id).to redirect_to(root_path)
      expect(delete :destroy, id: @user.id).to redirect_to(root_path)
      expect(get :show, id: @librarian.id).to redirect_to(root_path)
      expect(post :send_reminders).to redirect_to(root_path)
    end
  end


  describe 'as librarian' do

    before do
      @user = create :user
      @librarian = create :librarian
      sign_in @librarian
      request.env["HTTP_REFERER"] = "http://test.com/"
    end

    it 'redirects unauthorized users' do
      expect(delete :destroy, id: @user.id).to redirect_to(root_path)
      expect(@user.add_role(:admin)).to redirect_to(root_path)
    end

    it "GET 'index'" do
      get :index
      expect(assigns[:users]).to include @user
    end

    it "PUT 'update'" do
      put :update, id: @user, user: FactoryGirl.attributes_for(:user, email: "new@mewgle.com")
      @user.reload
      expect(@user.email).to eq("new@mewgle.com")
    end

    it "GET 'edit'" do
      get :edit, id: @user
      expect(response.status).to eq(200)
    end

    it "resets last_sent variable when sending overdue reminders" do
      expect{post :send_reminders}.to change{OverdueMailer.last_sent}
    end

  end


  describe 'as admin' do

    before do
      @user = create :user
      @admin = create :admin
      @librarian = create :librarian
      sign_in @admin
      request.env["HTTP_REFERER"] = "http://test.com/"
    end

    it "can change user roles" do
      @user.add_role(:admin)
      expect(@user.has_role?(:admin)).to eq(true)
    end

    it "DELETE 'destroy'" do
      expect{delete :destroy, id: @librarian.id}.to change{@librarian.reload.deactivated}.to(true)
    end

    it "can't DELETE 'destroy' self" do
      expect{delete :destroy, id: @admin.id}.to_not change{@admin.deactivated}
    end

    it "GET 'index'" do
      @deactivated_user = FactoryGirl.create(:user, deactivated: true)
      get :index
      expect(assigns[:users]).to include @user
      expect(assigns[:users]).to_not include @deactivated_user
    end

    it "PUT 'update'" do
      put :update, id: @user, user: {email: "new@mewgle.com"}
      expect(@user.reload.email).to eq("new@mewgle.com")
    end

    it "GET 'edit'" do
      get :edit, id: @user
      expect(response.status).to eq(200)
    end

  end

end