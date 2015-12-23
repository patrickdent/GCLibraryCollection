require 'spec_helper'

describe ReportsController do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @genre = create :genre
    @book1 = create :book, genre_id: @genre.id
    @book2 = create :book, missing: true
    @loan1 = create :loan, book_id: @book1.id
    create :loan, book_id: @book2.id
    @book3 = create :book
    @book4 = create :book, genre_id: @genre.id, missing: true
  end

  after :all do
    DatabaseCleaner.clean
  end

  describe "build report" do
    it "sets date range based on dates params" do
      post :build_report, report: "book-popularity", genre: 'all', dates: 'last-week'
      expect(assigns(:date_range)).to eq(1.week.ago.to_date..Date.today)
    end

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

    it "sorts book popularity report by loans within date range" do
      create :loan, book_id: @book4.id
      @loan1.update_attributes(start_date: 3.week.ago.to_date)
      post :build_report, report: "book-popularity", genre: @genre.id, dates: 'last-week'
      # book1's loan is outside the date range, so does not count
      expect(assigns(:books)).to eq([@book1, @book4])
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

    it "unpopular book report doesn't count loans outside date range" do
      request.env["HTTP_REFERER"] = reports_path
      @loan1.update_attributes(start_date: 3.week.ago.to_date)
      post :build_report, report: "unpopular-books", genre: @genre.id, dates: 'last-week'
      expect(assigns(:books)).to eq(nil)

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
