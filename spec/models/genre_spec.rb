require 'spec_helper'

describe Genre do

  let(:genre) { create(:genre) }

  subject { genre }

  describe "accessible attributes" do
    it "include name" do expect(subject).to respond_to(:name) end
    it "include abbreviation" do expect(subject).to respond_to(:abbreviation) end
  end

  describe "validations" do
    it "will not create a second genre with exact same name" do
      FactoryGirl.create(:genre, name: "Cool Genre")
      expect(FactoryGirl.build(:genre, name: "Cool Genre")).to_not be_valid
    end

    it "will not create an genre without a name" do
      expect(FactoryGirl.build(:genre, name: "")).to_not be_valid
    end
  end

  describe "search" do
    before :all do
      @genre1 = FactoryGirl.create(:genre, name: "Snacky" )
      @genre2 = FactoryGirl.create(:genre, name: "SnackTime" )
    end

    it "searches genres by name" do
      expect(Genre.search("SNACKY")).to eq([@genre1])
    end

    it "returns results alphabetized by name" do
      expect(Genre.search("snack")).to eq([@genre2, @genre1])
    end
  end

end