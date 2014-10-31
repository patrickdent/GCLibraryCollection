require 'spec_helper'

describe AuthorsController do

  before do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @author = create :author, name: "Abbie Abberson"
    @author2 = create :author, name: "Zed Zebrafish" 
    @author3 = create :author, sort_by: "Moo"
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
    it "shows all Authors" do 
      get :index 

      expect(assigns[:authors]).to include @author
    end 

    it "shows all Authors in alphabetical order" do 
      pending
      # WHY ISN'T THIS WORKING?!?!?!
      get :index 

      expect(assigns[:authors].first).to eq @author
      expect(assigns[:authors]).to include @author3
      expect(assigns[:authors].last).to eq @author2
    end 

  end 

  describe "GET 'show'" do 
    it "shows the specified author" do 
      get :show, id: @author.id 

      expect(assigns[:author]).to eq @author 
    end 
  end

  describe "POST 'create'" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(post :create, author: FactoryGirl.attributes_for(:author)).to redirect_to(root_path)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it "creates a new author" do
        expect{post :create, author: {name: "Mittens McScruff"}}.to change{Author.count}.by(1)
      end

      it "does not create a new author with bad data" do
        expect{post :create, author: {name: ""}}.to_not change{Author.count}
        expect(response).to redirect_to(new_author_path)
      end

      it "redirects to index" do
        expect(post :create, author: FactoryGirl.attributes_for(:author, name: 'testname1')).to redirect_to(authors_path)
      end
    end 
  end

  describe "DELETE destroy" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(delete :destroy, id: @author).to redirect_to(root_path)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it 'removes a author' do 
        expect{delete :destroy, id: @author}.to change{Author.count}.by(-1)
      end

      it 'redirects to Authors path' do
        expect(delete :destroy, id: @author).to redirect_to(authors_path)
      end
    end
  end

  describe "PUT update" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(put :update, id: @author).to redirect_to(root_path)
      end      
    end

    context 'as admin' do
      before { sign_in @admin }

      it "does not update with invalid params" do 
        post :update, id: @author.id, author: { name: "" }
        @author.reload 

        expect(@author.name).to_not eq("")
        expect(response.status).to eq(302)
      end 

      it 'changes the name' do
        put :update, id: @author, author: FactoryGirl.attributes_for(:author, name: "new and unique")
        @author.reload
        expect(@author.name).to eq("new and unique")
      end

      it 'redirects to author show' do
        put :update, id: @author, author: FactoryGirl.attributes_for(:author, name: "new and unique")
        expect(response).to redirect_to(author_path(@author))
      end
    end
  end
end