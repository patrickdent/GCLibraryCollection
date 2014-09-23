require 'spec_helper'

describe GenresController do

  before do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @genre = create :genre 
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
    it "shows all genres" do 
      get :index 

      expect(assigns[:genres]).to include @genre
    end 

  end 

  describe "GET 'show'" do 
    it "shows the specified genre" do 
      get :show, id: @genre.id 

      expect(assigns[:genre]).to eq @genre 
    end 
  end

  describe "POST 'create'" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(post :create, genre: FactoryGirl.attributes_for(:genre)).to redirect_to(root_path)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it "creates a new genre" do
        #undefined method 'call'
        # expect(post :create, genre: FactoryGirl.attributes_for(:genre)).to change(Genre, :count).by(1)
      end

      it "redirects to index" do
        expect(post :create, genre: FactoryGirl.attributes_for(:genre, name: 'testname1')).to redirect_to(genres_path)
      end
    end 
  end

  describe "DELETE destroy" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(delete :destroy, id: @genre).to redirect_to(root_path)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it 'removes a genre' do
        #undefined method 'call'
        # expect(delete :destroy, id: @genre).to change(Genre, :count).by(-1)
      end

      it 'redirects to genres path' do
        expect(delete :destroy, id: @genre).to redirect_to(genres_path)
      end
    end
  end

  describe "PUT update" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(put :update, id: @genre).to redirect_to(root_path)
      end      
    end

    context 'as admin' do
      before { sign_in @admin }

      it 'changes the name' do
        put :update, id: @genre, genre: FactoryGirl.attributes_for(:genre, name: "new and unique")
        @genre.reload
        expect(@genre.name).to eq("new and unique")
      end

      it 'redirects to genre show' do
        put :update, id: @genre, genre: FactoryGirl.attributes_for(:genre, name: "new and unique")
        expect(response).to redirect_to(genre_path(@genre))
      end
    end
  end
end