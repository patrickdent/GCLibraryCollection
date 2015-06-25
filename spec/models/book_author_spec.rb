require 'spec_helper'

describe BookAuthor do
  before :each do
    @book = create(:book)
    @author1 = create(:author)
    @author2 = create(:author)
    @book_author1 = create(:book_author, author_id: @author1.id, book_id: @book.id, primary: false)
    @book_author2 = create(:book_author, author_id: @author2.id, book_id: @book.id)
  end

  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  describe "removing book authors" do
    it "removes unwanted single book authors" do
      hash = {"#{@book_author1.id}"=>{"author_id"=>"#{@author1.id}", "contribution_id"=>"", "primary"=>"false"}}
      expect{BookAuthor::update_or_delete_from_book(@book, hash)}.to change{BookAuthor.count}.by(-1)
    end

    it "does not remove book authors that are sent to method" do
      hash = {"#{@book_author1.id}"=>{"author_id"=>"#{@author1.id}", "contribution_id"=>"", "primary"=>"false"}, "#{@book_author2.id}"=>{"author_id"=>"#{@author2.id}", "contribution_id"=>"", "primary"=>"false"}}
      expect{BookAuthor::update_or_delete_from_book(@book, hash)}.to change{BookAuthor.count}.by(0)
    end

    it "removes book authors that are not sent to method" do
      hash = {}
      expect{BookAuthor::update_or_delete_from_book(@book, hash)}.to change{BookAuthor.count}.by(-2)
    end
  end

   it "updates book authors" do
    hash = {"#{@book_author1.id}"=>{"author_id"=>"#{@author1.id}", "contribution_id"=>"", "primary"=>"true"}}
    BookAuthor::update_or_delete_from_book(@book, hash)
    expect(@book_author1.reload.primary).to eq(true)
  end

  describe "adding book authors" do
    it "creates book authors" do
      author3 = create(:author)
      author4 = create(:author)
      hash = { "new 557"=>{"author_id"=>"#{author3.id}", "contribution_id"=>"3", "primary"=>"false"},
               "new 210"=>{"author_id"=>"#{author4.id}", "contribution_id"=>"", "primary"=>"false"} }
      expect{BookAuthor.create_multi(@book, hash)}.to change{BookAuthor.count}.by(2)
    end
  end

end