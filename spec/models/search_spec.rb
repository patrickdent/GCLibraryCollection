require 'spec_helper'
require 'support/api_utilities'

describe Search do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  let(:isbn) { "1234567890" }

  describe "scrape" do

    context "good info" do

      # the example Json respons has three authors, on of whom is made into the @author variable below
      before do
        create_google_stub(create_google_url(isbn), "exists")
        @author = create(:author, name: "Fen Osler Hampson")
        @author_count = Author.all.length
        @book = Search.scrape(isbn)
      end

      it "will make a book from good info" do
        expect(@book).to eq Book.last
      end

      # one was made in the before block, so author count should only be two larger
      it "will find or make authors from good info" do
        expect(@author_count).to eq (Author.all.length - 2)
      end
    end

    it "will return nil if no book info comes back" do
      create_google_stub(create_google_url(isbn), "does not exist")
      expect(Search.scrape(isbn)).to eq nil
    end

    it "will not error if no author info present" do
      create_google_stub(create_google_url(isbn), "no authors")
      expect(Search.scrape(isbn)).to be_valid
    end

    it "will return nil if book with isbn already exists" do
      create_google_stub(create_google_url(isbn), "exists")
      Search.scrape(isbn)
      expect(Search.scrape(isbn)).to eq nil
    end
  end
end