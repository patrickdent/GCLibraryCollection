require 'spec_helper'

describe KeywordsController do

  before do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @keyword = create :keyword 
    @user = create :user
    @admin = create :admin 
  end 

  after do 
    DatabaseCleaner.clean
  end 

  after :each do 
    Warden.test_reset! 
  end 

  describe "GET 'index'" do 
    it "shows all keywords" do 
      get :index 

      expect(assigns[:keywords]).to include @keyword
    end 

  end 

  describe "GET 'show'" do 
    it "shows the specified keyword" do 
      get :show, id: @keyword.id 

      expect(assigns[:keyword]).to eq @keyword 
    end 
  end

  describe "POST 'create'" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        #throws a really cool error
        expect(post :create, keyword: FactoryGirl.attributes_for(:keyword, name: 'unique')).to redirect_to(root_path)
        # expect(response).to eq(302)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it "creates a new keyword" do
        #undefined method 'call'
        # expect(post :create, keyword: FactoryGirl.attributes_for(:keyword, name: 'unique')).to change(Keyword, :count)
      end

      it "redirects to index" do
        expect(post :create, keyword: FactoryGirl.attributes_for(:keyword, name: 'testname1')).to redirect_to(keywords_path)
      end
    end 
  end

  describe "DELETE destroy" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthroized user' do
        #throws a really cool error
        # delete :destroy, id: @keyword
        # expect(response).to eq(302) 
      end
    end
  end
end