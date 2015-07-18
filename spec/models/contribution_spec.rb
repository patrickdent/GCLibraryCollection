require 'spec_helper'

describe Contribution do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  let!(:contribution) { FactoryGirl.create(:contribution) }
  let!(:author) { FactoryGirl.create(:author) }
  let!(:book) { FactoryGirl.create(:book) }
  let!(:book_author) { FactoryGirl.create(:book_author, author: author, book: book, contribution: contribution)}

  subject { contribution }

  describe "accessible attributes" do
    it {should respond_to(:name) }
    it {should respond_to(:authors) }

    it "should have authors" do
      expect(contribution.authors).to_not be_empty
    end

  end

  describe "validations" do
    it "will not create a contribution without a name" do
      expect(FactoryGirl.build(:contribution, name: "")).to_not be_valid
    end

    it "will not create a contribution with a duplicate name" do
      expect(FactoryGirl.build(:contribution, name: contribution.name)).to_not be_valid
    end
  end



  describe "associations" do

    describe "should have an association to author" do

      it "via contribution" do
        expect(contribution.authors).to include(author)
      end

      it "via author" do
        expect(author.contributions).to include(contribution)
      end
    end
  end
end
