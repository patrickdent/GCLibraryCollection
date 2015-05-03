require 'spec_helper'

describe Keyword  do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  let(:keyword) { FactoryGirl.create(:keyword) }

  subject { keyword }

  describe "accessible attributes" do

    it "include name" do expect(subject).to respond_to(:name) end
    it "include books" do expect(subject).to respond_to(:books) end
    it "has name of keyword" do expect(subject.name).to eq "Boogers" end

  end

  describe "validations" do

    it "require name" do expect(FactoryGirl.build(:keyword, name: "")).to_not be_valid end

    context "duplicates" do
      before do
        FactoryGirl.create(:keyword, name: "duplicate")
      end
      it "are invalid" do expect(FactoryGirl.build(:keyword, name: "duplicate")).to_not be_valid end
    end
  end

  describe "search" do
    before :all do
      @keyword1 = FactoryGirl.create(:keyword, name: "yawn")
      @keyword2 = FactoryGirl.create(:keyword, name: "yarn")
    end

    it "searches keywords by name" do
      expect(Keyword.search("YaWN")).to eq([@keyword1])
    end

    it "returns results alphabetized by name" do
      expect(Keyword.search("ya")).to eq([@keyword2, @keyword1])
    end
  end
end