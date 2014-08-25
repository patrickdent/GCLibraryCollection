require 'spec_helper'

describe Contribution do
  let(:contribution) { FactoryGirl.create(:contribution) }

  subject { contribution }

  describe "accessible attributes" do
    it {should respond_to(:name) }

  end

    describe "validations" do
    it "will not create a contribution without a name" do  
      FactoryGirl.build(:contribution, name: "").should_not be_valid
    end 

    it "will not create a contribution with a duplicate name" do  
      FactoryGirl.build(:contribution, name: contribution.name).should_not be_valid
    end 
  end 
end
