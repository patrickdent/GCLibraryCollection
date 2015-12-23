require 'spec_helper'

describe ReportsController do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @genre = create :genre
    @book1 = create :book, genre_id: @genre.id
    @book2 = create :book, missing: true
    create :loan, book_id: @book1.id
    create :loan, book_id: @book2.id
    @book3 = create :book
    @book4 = create :book, genre_id: @genre.id, missing: true
  end

  after :all do
    DatabaseCleaner.clean
  end

  describe "build report" do
    it "builds the book popularity report for a genre" do
      post :build_report, report: "book-popularity", genre: @genre.id
      expect(assigns(:books)).to include(@book1)
      expect(assigns(:books)).to include(@book4)
    end

    it "book popularity report sorts by loan count" do
      post :build_report, report: "book-popularity", genre: @genre.id
      expect(assigns(:books)).to eq([@book4, @book1])
    end

    it "builds the book popularity report for all books, including those that have zero loans" do
      post :build_report, report: "book-popularity", genre: 'all'
      expect(assigns(:books)).to include(@book1)
      expect(assigns(:books)).to include(@book2)
      expect(assigns(:books)).to include(@book3)
      expect(assigns(:books)).to include(@book4)
    end

    it "builds the unpopular books report for a genre" do
      post :build_report, report: "unpopular-books", genre: @genre.id
      expect(assigns(:books)).to eq([@book4])
    end

    it "builds the unpopular books report for all books" do
      post :build_report, report: "unpopular-books", genre: 'all'
      expect(assigns(:books)).to include(@book3)
    end

    it "unpopular books report only shows books that have not been loaned" do
      post :build_report, report: "unpopular-books", genre: 'all'
      expect(assigns(:books)).to_not include(@book1)
      expect(assigns(:books)).to_not include(@book2)
    end

    it "builds the missing books report for a genre" do
      post :build_report, report: "missing-books", genre: @genre.id
      expect(assigns(:books)).to eq([@book4])
    end

    it "builds the missing books report for all books" do
      post :build_report, report: "missing-books", genre: 'all'
      expect(assigns(:books)).to include(@book2)
      expect(assigns(:books)).to include(@book4)
    end

    it "missing books report doesn't show books that aren't missing" do
      post :build_report, report: "missing-books", genre: 'all'
      expect(assigns(:books)).to_not include(@book1)
      expect(assigns(:books)).to_not include(@book3)
    end
  end
end
