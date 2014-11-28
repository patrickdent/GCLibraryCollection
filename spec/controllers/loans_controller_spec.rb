require 'spec_helper'

describe LoansController do

  before do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @book = create :book
    @user = create :user
    @librarian = create :librarian
  end 

  after do 
    DatabaseCleaner.clean
  end 

  after :each do 
    Warden.test_reset! 
  end 

  describe "POST 'create'" do
    context "as non-librarian" do
      before { sign_in @user }

      it "redirects unauthorized users home" do
        expect(post :create, loan: {user_id: 1, book_id: 1}).to redirect_to(root_path)
      end
    end

    context "as librarian" do
      before { sign_in @librarian }

      it "redirects authorized users to user" do
        expect(post :create, loan: {user_id: @user.id, book_id: @book.id}).to redirect_to(user_path(@user))
      end
    end
  end
end