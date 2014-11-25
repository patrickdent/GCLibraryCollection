class Loan < ActiveRecord::Base
  belongs_to :book 
  belongs_to :user

  after_create :set_start_date

  def self.loan_book(book, user)
    book.users << user
    return book.loans.where(user: user, returned_date: nil).first
  end

  private

  def set_start_date
    update_attribute(:start_date, Time.now) unless start_date
  end
 
end