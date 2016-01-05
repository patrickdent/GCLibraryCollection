require 'spec_helper'

describe AuthorsController do

  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @author = create :author, name: "Abbie Abberson"
    @author2 = create :author, name: "Zed Zzzz"
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
    it "shows all Authors in alphabetical order" do

      get :index

      expect(assigns[:authors].first).to eq @author
      expect(assigns[:authors].last).to eq @author2
    end

  end

  describe "GET 'show'" do
    it "shows the specified author" do
      get :show, id: @author.id

      expect(assigns[:author]).to eq @author
    end

    context "sorting" do
      before do
        agenre = create :genre, name: "a genre"
        lgenre = create :genre, name: "L genre"
        zgenre = create :genre, name: "z genre"
        @abook = create :book, title: "A title", genre_id: agenre.id
        @lbook = create :book, title: "l title", genre_id: lgenre.id
        @zbook = create :book, title: "z title", genre_id: zgenre.id
        create :book_author, author_id: @author.id, book_id: @abook.id
        create :book_author, author_id: @author.id, book_id: @lbook.id
        create :book_author, author_id: @author.id, book_id: @zbook.id
      end

      it "sorts the author's books by title based on params" do
        get :show, id: @author.id, sort: "title", direction: "asc"

        expect(assigns[:books].first).to eq(@abook)
        expect(assigns[:books][1]).to eq(@lbook)
        expect(assigns[:books].last).to eq(@zbook)

        get :show, id: @author.id, sort: "title", direction: "desc"

        expect(assigns[:books].first).to eq(@zbook)
        expect(assigns[:books][1]).to eq(@lbook)
        expect(assigns[:books].last).to eq(@abook)
      end

      it "sorts the author's books by genre based on params" do
        get :show, id: @author.id, sort: "cat_name", direction: "asc"

        expect(assigns[:books].first).to eq(@abook)
        expect(assigns[:books][1]).to eq(@lbook)
        expect(assigns[:books].last).to eq(@zbook)

        get :show, id: @author.id, sort: "cat_name", direction: "desc"

        expect(assigns[:books].first).to eq(@zbook)
        expect(assigns[:books][1]).to eq(@lbook)
        expect(assigns[:books].last).to eq(@abook)
      end
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