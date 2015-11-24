class Loan < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  after_create :set_lending_info
  after_create :update_book_availability

  scope :active, -> { where(returned_date: nil) }
  scope :overdue, -> { active.where("due_date < ?", Date.today) }

  DURATION = 30
  MAX_RENEWALS = 2

  def renew_loan
    if renewal_count < MAX_RENEWALS && !(user.do_not_lend) then
      update_attributes(due_date: (due_date + DURATION))
      update_attributes(renewal_count: ( renewal_count + 1 ) )
    else
      return false
    end
  end

  def overdue?
    active? && (due_date < Date.today)
  end

  def active?
    returned_date == nil
  end

  private

  def set_lending_info
    update_attributes(start_date: Time.now.to_date) unless start_date
    update_attributes(due_date: DURATION.days.from_now) unless due_date
    update_attributes(renewal_count: 0) unless renewal_count
  end

  def update_book_availability
    book.update_availability
  end
end