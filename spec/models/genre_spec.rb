require 'spec_helper'

describe Genre do

  describe "validations" do
    it "will not create a second genre with exact same name" do 
      FactoryGirl.create(:genre, name: "Cool Genre") 
      FactoryGirl.build(:genre, name: "Cool Genre").should_not be_valid
    end

    it "will not create an genre without a name" do 
      FactoryGirl.build(:genre, name: "").should_not be_valid
    end  
  end 

end