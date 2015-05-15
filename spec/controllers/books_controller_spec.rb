# spec/controllers/search_controller_spec.rb
require 'spec_helper'

describe BooksController do

  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @book = create :book
    @user = create :user
    @admin = create :admin
    @librarian = create :librarian
    @patron = create :user
    @selected_book = create :book
    @unselected_book = create :book
  end

  after :all do
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

  describe "POST 'remove addtional copy'" do
    before { request.env["HTTP_REFERER"] = book_path(@book) }

    it "decreases count if more than one copy" do
      sign_in @admin
      @book.update_attributes(count: 2)
      post :remove_copy, id: @book.id
      @book.reload
      expect(@book.count).to eq(1)
    end

    it "doesn't decrease count if less than 2 copies" do
      sign_in @admin
      @book.update_attributes(count: 1)
      post :remove_copy, id: @book.id
      @book.reload
      expect(@book.count).to eq(1)
    end

    it "doesn't decrease count if non-admin" do
      sign_in @librarian
      @book.update_attributes(count: 2)
      post :remove_copy, id: @book.id
      @book.reload
      expect(@book.count).to eq(2)
    end
  end

  describe "POST 'update'" do
    context 'when no admin is logged in' do
      it "does not allow unauthorized users to make changes" do
        post :update, id: @book.id, book: { title: "Whiskers and Black Lace" }
        @book.reload

        expect(@book.title).to eq("Kittypuss: an History")
        expect(response.status).to eq(302)
      end
    end

    context 'when admin is logged in' do
      it "allows authorized user to update with valid params" do
        sign_in @admin
        post :update, id: @book.id, book: { title: "Whiskers and Black Lace" }
        @book.reload

        expect(@book.title).to eq("Whiskers and Black Lace")
      end
      it "does not update with invalid params" do
        sign_in @admin
        post :update, id: @book.id, book: { title: "" }
        @book.reload

        expect(@book.title).to eq("Kittypuss: an History")
        expect(response.status).to eq(302)
      end
    end
  end

  describe "POST 'create'" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(post :create, book: FactoryGirl.attributes_for(:book)).to redirect_to(root_path)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it "creates a new book" do
        expect{post :create, book: {title: "Touch My Belly... Trust Me"}}.to change{Book.count}.by(1)
      end

      it "redirects to index" do
        expect(post :create, book: FactoryGirl.attributes_for(:book, title: 'testname1')).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE destroy" do

    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unbookized user' do
        expect(delete :destroy, id: @book).to redirect_to(root_path)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it 'removes a book' do
        expect{delete :destroy, id: @book}.to change{Book.count}.by(-1)
      end

      it 'redirects to Authors path' do
        expect(delete :destroy, id: @book).to redirect_to(root_path)
      end
    end
  end

  describe "GET show_list" do
    context 'librarian logged in' do
      it "returns the selected books" do
        sign_in @librarian
        session[:selected_books] = [@selected_book.id]
        get :show_list
        expect(assigns[:books]).to include(@selected_book)
      end
    end

    context 'patron logged in' do
      it "does not return the selected books" do
        sign_in @patron
        get :show_list
        expect(assigns[:books]).to be_nil
      end
    end

  end

  describe "GET clear_list" do
    context 'librarian logged in' do
      it "clears all books" do
        sign_in @librarian
        session[:selected_books] = [@selected_book.id]
        get :clear_list
        expect(session[:selected_books]).to eq(nil)
      end
    end
  end

  describe "POST list" do
    context 'librarian logged in' do
      it "changes the selected status of the book" do
        sign_in @librarian
        post :list, book: {id: @unselected_book.id, selected: true}
        expect(session[:selected_books]).to include(@unselected_book.id)
      end
    end
  end
end