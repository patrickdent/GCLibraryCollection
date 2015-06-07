require 'spec_helper'

describe BookAuthorsController do

  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    request.env["HTTP_REFERER"] = root_path
    @book = create :book
    @author = create :author, name: "Abbie Abberson"
    @ba = BookAuthor.create(book_id: @book.id, author_id: @author.id)
    @contribution = Contribution.create(name: "Chief Snuggler")
    @user = create :user
    @admin = create :admin
  end

  after do
    DatabaseCleaner.clean
    Warden.test_reset!
  end

  describe "GET 'manage_contributions'" do
    context 'as admin' do
      before { sign_in @admin }

      it "returns book_authors" do
        xhr :get, :manage_contributions, subjects: [@ba.id]

        expect(assigns(:book_authors)).to include(@ba)
      end
    end
  end

  describe "POST 'update_contributions'" do
    context 'as non-admin' do
      before { sign_in @user }

      it 'redirects unauthorized user' do
        expect(post :update_contributions, book_author: {@ba.id =>{contribution_id: @contribution.id}}).to redirect_to(root_path)
      end
    end

    context 'as admin' do
      before { sign_in @admin }

      it "sets a contribution" do
        post :update_contributions, book_author: {@ba.id =>{contribution_id: @contribution.id}}
        expect(@ba.reload.contribution_id).to eq(@contribution.id)
      end

      it "does not set to an invalid contribution" do
        expect{post :update_contributions, book_author: {@ba.id =>{contribution_id: "bananas"}}}.to_not change{@ba.contribution_id}
      end

      it "unsets a contribution" do
         post :update_contributions, book_author: {@ba.id =>{contribution_id: ""}}
        expect(@ba.reload.contribution_id).to eq(nil)
      end
    end
  end


end