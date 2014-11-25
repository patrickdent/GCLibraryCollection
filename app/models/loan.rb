class Loan < ActiveRecord::Base
  belongs_to :book 
  belongs_to :user

  after_create :set_start_date

  private

  def set_start_date
    update_attribute(:start_date, Time.now) unless start_date
  end
 
end