require 'spec_helper'

describe Author do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  describe "validations" do
    it "will not create a second author with exact same name" do
      FactoryGirl.create(:author, name: "Steve Bobs")

      expect(FactoryGirl.build(:author, name: "Steve Bobs")).to_not be_valid
    end

    it "will not create an author without a name" do
      FactoryGirl.build(:author, name: "").should_not be_valid
    end
  end

  it "destroys its dependent book_authors on delete" do
    author = create(:author)
    BookAuthor.create(book_id: create(:book).id, author_id: (author.id))
    expect{ author.destroy }.to change{ BookAuthor.count }.by(-1)
  end

  describe "sort_by_name" do
    before do
      @author = FactoryGirl.create(:author, name: "One Two Three")
      @author2 = FactoryGirl.create(:author, name: "First Middle Last", sort_by: "Middle")
    end
    it "will return the sort_by attribute of an author that has one" do
      expect(@author2.sort_by_name).to eq("Middle")
    end

    it "will set the sort_by of an author that does not have one" do
      expect(@author.sort_by_name).to eq("Three")
      expect(@author.sort_by).to eq("Three")
    end

    it "will not overwrite a sort_by that is set" do
      @author2.sort_by_name
      expect(@author2.sort_by).to eq("Middle")
    end
  end

  describe "search" do
    before :all do
      @author1 = FactoryGirl.create(:author, name: "Jingles Butterworth" )
      @author2 = FactoryGirl.create(:author, name: "Jingles Zipperz" )
    end

    it "searches authors by name" do
      expect(Author.search("Butterworth")).to eq([@author1])
    end

    it "returns results alphabetized by name" do
      expect(Author.search("Jingles")).to eq([@author1, @author2])
    end
  end

end