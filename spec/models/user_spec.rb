require 'spec_helper'
describe User do

  describe "accessible attributes" do
    let(:user) { FactoryGirl.create :user }
    subject { user }

    it { should respond_to(:email) }
    it { should respond_to(:username) }
    it { should respond_to(:notes) }
    it { should respond_to(:name) }
    it { should respond_to(:phone) }
    it { should respond_to(:sort_by) }
    it { should respond_to(:address) }
    it { should respond_to(:do_not_lend) }
    it { should respond_to(:identification) }
  end

  describe "email not required" do 
    let(:no_email_user) { FactoryGirl.create :user, email: "", username: "SweetPea" }
    it "is not required" do 
      expect(no_email_user).to be_valid 
    end 
  end 

  describe "username" do 
    it "should be case-insensitively unique" do 
      FactoryGirl.create :user, username: "MrWhiskers"
      expect(FactoryGirl.build :user, email: "", username: "MRWHISKERS").to_not be_valid
    end   
  end 

end