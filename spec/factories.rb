FactoryGirl.define do

  factory :book, class: Book do
    title     "Kittypuss: an History"
    isbn      "123456789"
  end

  factory :author, class: Author do
    sequence :name do |n|
      "Kitty #{n}"
    end
  end

  factory :book_author, class: BookAuthor do
  end

  factory :genre, class: Genre do
    sequence :name do |n|
      "Kitty Interests #{n}"
    end

    sequence :abbreviation do |n|
      "KI #{n}"
    end
  end

  factory :user, class: User do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    sequence :name do |n|
      "Meowlexander the #{n}"
    end
    address "99 SoftPaws Ln"
    city "Seattle"
    state "WA"
    zip "98102"
    phone "206-999-0909"
    password "password"
    password_confirmation "password"
    do_not_lend false
    identification "valid"
  end

  factory :librarian, class: User do
    sequence :email do |n|
      "librarianuser#{n}@example.com"
    end
    sequence :name do |n|
      "Walt Whiskman the #{n}"
    end
    address "99 SoftPaws Ln"
    city "Seattle"
    state "WA"
    zip "98102"
    phone "206-999-0909"
    password "password"
    password_confirmation "password"
    after(:create) {|user| user.add_role(:librarian) }
  end

  factory :admin, class: User do
    sequence :email do |n|
      "adminuser#{n}@example.com"
    end
    sequence :name do |n|
      "Genghis Yawn the #{n}"
    end
    address "99 SoftPaws Ln"
    city "Seattle"
    state "WA"
    zip "98102"
    phone "206-999-0909"
    password "password"
    password_confirmation "password"
    after(:create) {|user| user.add_role(:admin) }
  end

  factory :keyword, class: Keyword do
    name "Boogers"
  end

  factory :contribution, class: Contribution do
    name "illustrator"
  end

  factory :loan, class: Loan do
    :book
    :user
  end
end