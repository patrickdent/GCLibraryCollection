FactoryGirl.define do
  factory :book do
    #simple starting data
    title     "Kittypuss: an History"
    isbn      "123456789"

    #for when we want to populate the database with a lot of data
    # Sequence(:title)  { |n| "Title #{n}" }
    # # only good for 10 books
    # Sequence(:isbn)   { |n| "12345678#{n}"}
  end

  factory :author do
    #simple starting data
    name      "Chairman Meow"

    #for when we want to populate the database with a lot of data
    # Sequence(:name)   { |n| "Author #{n}" }
  end

  factory :genre do

    #simple starting data
    name      "Meowstory"

    #for when we want to populate the database with a lot of data
    # Sequence(:name)   { |n| "Genre #{n}" }
  end
  
end