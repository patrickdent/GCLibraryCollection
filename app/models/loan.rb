class Loan < ActiveRecord::Base
  belongs_to :book 
  belongs_to :user

  after_create :set_lending_info

  DURATION = 30

  def return_book
    update_attribute(:returned_date, Time.now.to_date)
    return returned_date
  end

  def renew_loan
    update_attribute(:due_date, (due_date + DURATION))
    update_attribute(:renewal_count, ( renewal_count + 1 ) )
    return due_date
  end

  private

  def set_lending_info
    update_attribute(:start_date, Time.now.to_date) unless start_date
    update_attribute(:due_date, DURATION.days.from_now) unless due_date 
    update_attribute(:renewal_count, 0) unless renewal_count
  end
end