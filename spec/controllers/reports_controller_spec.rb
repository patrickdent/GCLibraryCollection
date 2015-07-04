require 'spec_helper'

describe ReportsController do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @genre = create :genre
    @book = create :book, genre_id: @genre.id
  end

  after :all do
    DatabaseCleaner.clean
  end

  describe "build report" do
    it "builds the book popularity report" do
      post :build_report, report: "book-popularity", genre: @genre.id
      expect(assigns(:books)).to eq([@book])
    end
  end

end