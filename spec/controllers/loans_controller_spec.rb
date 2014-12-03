require 'spec_helper'

describe LoansController do

  before do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @book = create :book
    @user = create :user
    @librarian = create :librarian
    @loan = create(:loan, user_id: @user.id, book_id: @book.id)
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

      it "redirects to user#show" do
        expect(post :create, loan: {user_id: @user.id, book_id: @book.id}).to redirect_to(user_path(@user))
      end

      it "creates a new loan" do
        expect { post :create, loan: { user_id: @user.id, book_id: @book.id } }.to change(Loan, :count).by(1)
      end
    end
  end

  describe "PUT renew" do
    context 'as non-librarian' do
      before { sign_in @user }

      it 'redirects unauthorized user home' do
        expect(put :renew, id: @loan.id).to redirect_to(root_path)
      end      
    end

    context 'as librarian' do
      before { sign_in @librarian }

      it 'redirects to user#show' do
        expect(put :renew, id: @loan.id).to redirect_to(user_path(@user.id))
      end

      it 'changes due_date' do
        original_date = @loan.due_date
        put :renew, id: @loan.id
        expect(@loan.reload.due_date).to_not eq(original_date)
      end      
    end
  end

  describe "PUT return" do
    context 'as non-librarian' do
      before { sign_in @user }

      it 'redirects unauthorized user home' do
        expect(put :return, id: @loan.id).to redirect_to(root_path)
      end      
    end

    context 'as librarian' do
      before { sign_in @librarian }

      it 'redirects to user#show' do
        expect(put :return, id: @loan.id).to redirect_to(user_path(@user.id))
      end      

      it 'sets a returned_date' do
        put :return, id: @loan.id
        expect(@loan.reload.returned_date).to_not eq(nil)
      end      
    end
  end

  describe "GET show" do
    context 'as non-librarian' do

      it 'redirects home for other user loans' do
        @user2 = create :user 
        sign_in @user2
        expect(get :show, id: @loan.id).to redirect_to(root_path)
      end 

      it "doesn't redirect for own loans" do
        sign_in @user
        get :show, id: @loan.id
        expect(response).to_not be_redirect
      end      
    end

    context 'as librarian' do
      before { sign_in @librarian }

      it "doesn't redirect to home" do
        get :show, id: @loan.id
        expect(response).to_not be_redirect
      end      
    end
  end

  describe "GET index" do
    context 'as non-librarian' do
      before { sign_in @user }

      it 'redirects home' do
        expect(get :index).to redirect_to(root_path)
      end    
    end

    context 'as librarian' do
      before { sign_in @librarian }

      it "doesn't redirect to home" do
        get :index
        expect(response).to_not be_redirect
      end      
    end
  end
end