require 'spec_helper'

describe LoansController do

  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @book = create :book
    @user = create :user
    @complete_user = create :user, identification: "MIAO-MIAO-99"
    @librarian = create :librarian
    @loan = create(:loan, user_id: @user.id, book_id: @book.id)
  end

  before(:each) do
    request.env["HTTP_REFERER"] = root_path
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

      it "redirects to :back" do
        expect(post :create, loan: {user_id: @complete_user.id, book_id: @book.id}).to redirect_to(root_path)
      end

      it "creates a new loan for a user who's good to borrow" do
        expect { post :create, loan: { user_id: @complete_user.id, book_id: @book.id } }.to change(Loan, :count).by(1)
      end

      it "doesn't create a new loan for a user who isn't good to borrow" do
        expect { post :create, loan: { user_id: @user.id, book_id: @book.id } }.to change(Loan, :count).by(0)
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

      it 'redirects to :back' do
        expect(put :renew, id: @loan.id).to redirect_to(root_path)
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

      it 'redirects to :back' do
        expect(put :return, id: @loan.id).to redirect_to(root_path)
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

  describe 'POST multi loan' do
    before do
      @books = [@book]
      User::MAX_LOANS.times do
        @books << (create :book)
      end
      @books.map { |b| b.id }
      sign_in @librarian
    end

    context 'with good data' do
      it 'creates all loans' do
        expect { post :loan_multi, {user_id: @complete_user.id, book_ids: @books[0..(User::MAX_LOANS - 1)]} }.to change(Loan, :count).by(User::MAX_LOANS)
      end
    end

    context 'with incorrect data' do
      it 'doesn\'t accept more than max loans' do
        expect { post :loan_multi, {user_id: @complete_user.id, book_ids: @books} }.to change(Loan, :count).by(0)
      end

      it 'doesn\'t create more than max loans' do
        post :loan_multi, {user_id: @complete_user.id, book_ids: @books[0..(User::MAX_LOANS - 1)]}
        expect { post :loan_multi, {user_id: @complete_user.id, book_ids: [@books[User::MAX_LOANS]]} }.to change(Loan, :count).by(0)
      end

      it 'doesn\'t accept nil user' do
        expect { post :loan_multi, {user_id: nil, book_ids: [@books[0]]} }.to change(Loan, :count).by(0)
      end

      it 'doesn\'t accept blank book' do
        expect { post :loan_multi, {user_id: @complete_user.id, book_ids: []} }.to change(Loan, :count).by(0)
      end

      context 'flash messages' do
        before do
          sign_in @librarian
          visit root_path
        end

        it 'for no selected books' do
          post :loan_multi, {user_id: @complete_user.id}
          expect(flash[:alert]).to eq("No items selected.")
        end

        it 'for blank user' do
          post :loan_multi, {book_ids: [@books[0]]}
          expect(flash[:alert]).to eq("No user selected.")
        end

        it 'for unavailable book' do
          Book.find(@books[5]).update_attribute(:available, false)
          post :loan_multi, {user_id: @complete_user.id, book_ids: [@books[5]]}
          expect(flash[:alert]).to eq("One or more of the selected items is unavailable.")
        end

        it 'for nil books' do
          post :loan_multi, {user_id: @complete_user.id, book_ids: []}
          expect(flash[:alert]).to eq("Loan creation failed.")
        end
      end
    end
  end
end