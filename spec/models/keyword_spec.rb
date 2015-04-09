require 'spec_helper'

describe Keyword  do
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
    it "searches keywords by name" do
      keyword = FactoryGirl.create(:keyword, name: "yawn")
      expect(Keyword.search("YaWN")).to eq([keyword])
    end
  end
end