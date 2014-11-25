require 'spec_helper'

describe Loan do
  let(:user) { create :user }
  let(:book) { create :book }
  let(:loan) { Loan.loan_book(book, user) }

  it "has user" do expect(loan.user).to eq(user) end
  it "has book" do expect(loan.book).to eq(book) end
  it "has start date" do expect(loan).to respond_to(:start_date) end
  it "has due date" do expect(loan).to respond_to(:due_date) end
  it "has returned date" do expect(loan).to respond_to(:returned_date) end
  it "has renewal count" do expect(loan).to respond_to(:renewal_count) end

end