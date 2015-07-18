require 'spec_helper'

describe Book do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  let(:book) { FactoryGirl.create(:book, title: "Kittypuss: an History", isbn: "123456789" ) }

  subject { book }

  describe "accessible attributes" do
    its(:title) { should == "Kittypuss: an History" }
    its(:isbn)  { should == "123456789" }
    it { should respond_to(:language) }
    it { should respond_to(:publisher) }
    it { should respond_to(:publish_date) }
    it { should respond_to(:publication_place) }
    it { should respond_to(:authors) }
    it { should respond_to(:title) }
    it { should respond_to(:genre) }
    it { should respond_to(:pages) }
    it { should respond_to(:keywords) }
    it { should respond_to(:location) }
    it { should respond_to(:in_storage) }
    it { should respond_to(:notable) }
    it { should respond_to(:keep_multiple) }
  end

  describe "validations" do
    it "will not create a book without a title" do
      FactoryGirl.build(:book, title: "").should_not be_valid
    end
  end

  describe "search" do
    before :all do
      @book1 = FactoryGirl.create(:book, title: "Boogers and Their Uses", isbn: "9988998899" )
      @book2 = FactoryGirl.create(:book, title: "My Boy Boogers", isbn: "998888383" )
    end

    it "searches books by title and isbn" do
      expect(Book.search("Their Uses")).to eq([@book1])
      expect(Book.search("9988998899")).to eq([@book1])
    end

    it "returns results alphabetized by title" do
      expect(Book.search("Boogers")).to eq([@book1, @book2])
    end
  end
end