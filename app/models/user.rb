class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login
  validates :username, uniqueness: {case_sensitive: false, allow_nil: true, allow_blank: true}
  validates :email, uniqueness: {case_sensitive: false, allow_nil: true, allow_blank: true}
  validates :name, presence: true
  validates :address, presence: true
  validates :phone, presence: true

  has_many :loans
  has_many :books, through: :loans

  scope :active, -> {where(deactivated: false)}

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

  def good_to_borrow?(books_to_borrow = 1)
    #organization-specific borrowing rules
    if !do_not_lend && contains_field?(name) && (contains_field?(email) || contains_field?(phone)) &&
        contains_field?(identification) && (loans.active.count + books_to_borrow) < (User::MAX_LOANS + 1)
      return true
    else
      return false
    end
  end

  def contains_field?(string)
    return false if string.nil? || string.blank?
    true
  end

  def pref_name
    preferred_first_name || name.split.first
  end

  def self.able_to_borrow
    active.select{|u| u.good_to_borrow? }
  end

  def self.search(search)
    search_length = search.split.length
    active.where([(['lower(preferred_first_name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }) +
    active.where([(['lower(name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }).order(:name)
  end

  def deactivate
    update_attributes(deactivated: true)
  end
end
