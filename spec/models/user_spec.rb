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
    it { should respond_to(:preferred_first_name) }
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

  describe "good to borrow?" do
    it "should require that do_not_lend is not true to borrow" do
      bad_user = FactoryGirl.create :user, do_not_lend: true
      expect(bad_user.good_to_borrow?).to be_false
    end

    it "should require a name" do
      bad_user = FactoryGirl.create :user
      bad_user.name = ''
      bad_user_2 = FactoryGirl.create :user
      bad_user_2.name = nil
      expect(bad_user.good_to_borrow?).to be_false
      expect(bad_user_2.good_to_borrow?).to be_false
    end

    it "should require contact info" do
      bad_user = FactoryGirl.create :user
      bad_user.email = nil
      bad_user.phone = nil
      bad_user_2 = FactoryGirl.create :user
      bad_user_2.email = ''
      bad_user_2.phone = ''
      expect(bad_user.good_to_borrow?).to be_false
      expect(bad_user_2.good_to_borrow?).to be_false
    end

    it "should require identification" do
      bad_user = FactoryGirl.create :user
      bad_user.identification = nil
      bad_user_2 = FactoryGirl.create :user
      bad_user_2.identification = ''
      expect(bad_user.good_to_borrow?).to be_false
      expect(bad_user_2.good_to_borrow?).to be_false
    end

    it "should not lend beyond MAX_LOANS" do
      bad_user = FactoryGirl.create :user
      expect(bad_user.good_to_borrow?(User::MAX_LOANS + 1)).to be_false
    end
  end

  describe "search" do
    it "searches users by name and preferred name" do
      user = FactoryGirl.create(:user, name: "Jingles Butterworth", preferred_first_name: "Theodore")
      expect(User.search("Butterworth")).to eq([user])
      expect(User.search("Theodore")).to eq([user])
    end
  end

end