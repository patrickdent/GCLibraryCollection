class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login
  validates :username, uniqueness: {case_sensitive: false, allow_nil: true}
  has_many :loans
  has_many :books, through: :loans

  MAX_LOANS = 5

  def role
    return roles.first.name.to_sym if roles.first
    nil
  end

  def email_required?
    false
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def good_to_borrow?
    #organization-specific borrowing rules
    if self.name && (self.email || self.phone) && !self.do_not_lend && self.loans.active.count < 5
      true 
    end 
  end 

end
