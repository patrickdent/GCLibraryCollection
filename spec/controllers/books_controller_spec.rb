# spec/controllers/search_controller_spec.rb
require 'spec_helper' 

describe BooksController do

  before do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @book = create :book 
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
    it "should show all books" do 
      get :index 

      expect(assigns[:books]).to include @book
    end 

  end 

  describe "GET 'show'" do 
    it "should show the specified book" do 
      get :show, id: @book.id 

      expect(assigns[:book]).to eq @book 
    end 
  end 

  describe "GET 'edit'" do 
    context 'when no admin is logged in' do  
      it "redirects unauthorized user" do 
        get :edit, id: @book.id
        expect(response.status).to eq(302)
      end 
    end

    context 'when admin is logged in' do
      it "allows user to edit" do 
        sign_in @admin
        get :edit, id: @book.id 
        expect(response.status).to eq(200) 
      end 
    end
  end 

  describe "POST 'update'" do 
    context 'when no admin is logged in' do  
      it "does not allow unauthorized users to make changes" do 
        post :update, id: @book.id, book: { title: "Whiskers and Black Lace" }
        @book.reload 

        expect(@book.title).to eq("Kittypuss: an History")
      end 
    end

    context 'when admin is logged in' do
      it "allows user to edit" do 
        sign_in @admin
        post :update, id: @book.id, book: { title: "Whiskers and Black Lace" }
        @book.reload 

        expect(@book.title).to eq("Whiskers and Black Lace")      
      end 
    end
  end 

end 