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
        expect(post :create, keyword: FactoryGirl.attributes_for(:keyword)).to redirect_to(root_path)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it "creates a new keyword" do
        expect {post :create, keyword: {name: "TestKeyword9000"} }.to change{Keyword.count}.by(1)
      end

      it "redirects to index" do
        expect(post :create, keyword: FactoryGirl.attributes_for(:keyword, name: 'testname1')).to redirect_to(keywords_path)
      end
    end 
  end

  describe "DELETE destroy" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(delete :destroy, id: @keyword).to redirect_to(root_path)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it 'removes a keyword' do
        expect {delete :destroy, id: @keyword}.to change{Keyword.count}.by(-1)
      end

      it 'redirects to keywords path' do
        expect(delete :destroy, id: @keyword).to redirect_to(keywords_path)
      end
    end
  end

  describe "PUT update" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(put :update, id: @keyword).to redirect_to(root_path)
      end      
    end

    context 'as admin' do
      before { sign_in @admin }

      it "does not update with invalid params" do 
        post :update, id: @keyword.id, keyword: { name: "" }
        @keyword.reload 

        expect(@keyword.name).to_not eq("")
        expect(response.status).to eq(302)
      end 

      it 'changes the name' do
        put :update, id: @keyword, keyword: FactoryGirl.attributes_for(:keyword, name: "new and unique")
        @keyword.reload
        expect(@keyword.name).to eq("new and unique")
      end

      it 'redirects to keyword show' do
        put :update, id: @keyword, keyword: FactoryGirl.attributes_for(:keyword, name: "new and unique")
        expect(response).to redirect_to(keyword_path(@keyword))
      end
    end
  end
end