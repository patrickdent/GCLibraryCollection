require 'spec_helper'

describe Loan do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  let(:user) { create :user }
  let(:book) { create :book }
  let(:loan) { create :loan, book_id: book.id, user_id: user.id }

  it "has user" do expect(loan.user).to eq(user) end
  it "has book" do expect(loan.book).to eq(book) end
  it "has start date" do expect(loan).to respond_to(:start_date) end
  it "has due date" do expect(loan.due_date).to eq(Loan::DURATION.days.from_now.to_date) end
  it "has returned date" do expect(loan).to respond_to(:returned_date) end
  it "has renewal count" do expect(loan).to respond_to(:renewal_count) end

  describe "validations" do
    it "requires a user" do
      expect(Loan.new(book_id: book.id, start_date: Date.today)).to_not be_valid
    end

    it "requires a book" do
      expect(Loan.new(user_id: user.id, start_date: Date.today)).to_not be_valid
    end
  end

  describe "renewing books" do
    before { @loan = Loan.create( book_id: (create :book).id, user_id: (create :user).id ) }

    it "will not renew for 'do_not_lend' users" do
      old_date = @loan.due_date
      @loan.user.do_not_lend = true
      @loan.renew_loan
      expect(@loan.due_date).to eq(old_date)
    end

    it "will not renew for more than twice" do
      old_date = @loan.due_date
      @loan.renewal_count = 2
      @loan.renew_loan
      expect(@loan.due_date).to eq(old_date)
    end

    it "sets a new return date" do
      old_date = @loan.due_date
      date = old_date + Loan::DURATION
      @loan.renew_loan
      expect(@loan.due_date).to_not eq(old_date)
      expect(date).to eq(@loan.due_date)
    end

    it "increments renewal count" do
      old_count = @loan.renewal_count
      @loan.renew_loan
      count = @loan.renewal_count
      expect(count).to eq(old_count + 1)
    end
  end
end