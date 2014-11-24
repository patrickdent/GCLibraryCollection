FactoryGirl.define do
  
  factory :book, class: Book do
    #simple starting data
    title     "Kittypuss: an History"
    isbn      "123456789"
  end

  factory :author, class: Author do
    #for when we want to populate the database with a lot of data
    sequence :name do |n| 
      "Kitty #{n}" 
    end
  end

  factory :book_author, class: BookAuthor do

  end

  factory :genre, class: Genre do
    #for when we want to populate the database with a lot of data
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
    password "password"
    password_confirmation "password" 
  end 

  factory :librarian, class: User do 
    sequence :email do |n| 
      "librarianuser#{n}@example.com" 
    end
    password "password"
    password_confirmation "password" 
    after(:create) {|user| user.add_role(:librarian) }
  end 

  factory :admin, class: User do 
    sequence :email do |n| 
      "adminuser#{n}@example.com" 
    end
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
end