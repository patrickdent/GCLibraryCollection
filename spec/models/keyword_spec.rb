require 'spec_helper'

describe Keyword  do
  let(:keyword) { FactoryGirl.create(:keyword) }

  subject { keyword }

  describe "accessible attributes" do

    it "include keyword" do expect(subject).to respond_to(:keyword) end
    it "include books" do expect(subject).to respond_to(:books) end
    it "has keyword of keyword" do expect(subject.keyword).to eq "keyword" end

    #I thought we added this relationship...
    # it "include authors" do expect(subject).to respond_to(:authors) end
    
  end


end