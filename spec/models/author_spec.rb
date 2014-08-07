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

end