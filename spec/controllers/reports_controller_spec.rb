require 'spec_helper'

describe ReportsController do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @genre = create :genre
    @book1 = create :book, genre_id: @genre.id
    @book2 = create :book
    create :loan, book_id: @book1.id
    create :loan, book_id: @book2.id
    @book3 = create :book
  end

  after :all do
    DatabaseCleaner.clean
  end

  describe "build report" do
    it "builds the book popularity report for a genre" do
      post :build_report, report: "book-popularity", genre: @genre.id
      expect(assigns(:books)).to eq([@book1])
    end

    it "builds the book popularity report for all books" do
      post :build_report, report: "book-popularity", genre: 'all'
      expect(assigns(:books)).to include(@book1)
      expect(assigns(:books)).to include(@book2)
    end

    it "only shows books that have been loaned" do
      post :build_report, report: "book-popularity", genre: 'all'
      expect(assigns(:books)).to_not include(@book3)
    end
  end

end