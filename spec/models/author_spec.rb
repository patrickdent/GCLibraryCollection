require 'spec_helper'

describe Author do

  describe "validations" do
    it "will not create a second author with exact same name" do   
      FactoryGirl.create(:author, name: "Steve Bobs")

      FactoryGirl.build(:author, name: "Steve Bobs").should_not be_valid
    end

    it "will not create an author without a name" do 
      FactoryGirl.build(:author, name: "").should_not be_valid
    end  
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
end