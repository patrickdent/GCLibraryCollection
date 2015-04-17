genres = Genre.create([{ name: "Whisker Grooming", abbreviation: "WG"  },
                       { name: "Comfortable Positions", abbreviation: "CoPo"  },
                       { name: "Ew, Gross", abbreviation: "EGr"  }])

Genre.create(name: "Unassigned", abbreviation: "UA")

authors = Author.create([{ name: "Chairman Meow" },
                         { name: "Fluffy Faulkner"},
                         { name: "B. Author" },
                         { name: "Boots McNally"}])

books = Book.create([{ title: "Kittles and Bits", genre: genres[0], isbn: 1234567890 },
                     { title: "I Am Who Am I?", genre: genres[1], isbn: 1123456789 },
                     { title: "The Sound and the Furry", genre: genres[0], isbn: 1112345678 },
                     { title: "Meowtains", genre: genres[2], isbn: 1111234567 }])

keywords = Keyword.create([{ name: "good" },
                           { name: "bad" },
                           { name: "furry"}])

@int = 0
books.each do |b|
  BookKeyword.create(book: b, keyword: keywords[(@int += 1) % keywords.count])
  BookKeyword.create(book: b, keyword: keywords[(@int += 1) % keywords.count])
end

authors.each do |a|
  BookAuthor.create(book: books[(@int += 1) % books.count], author: a)
  BookAuthor.create(book: books[(@int += 1) % books.count], author: a)
end

(1..70).each do |i|
  BookAuthor.create(author: authors[i % authors.count],
                    book: Book.create(title: "Test Book #{i}",
                                      genre: genres[i % genres.count]))
end

u = User.new(
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  preferred_first_name: "Adonis",
  name: "Ad Meownistrator",
  address: "99 SoftPaws Ln, Seattle, WA 98122",
  phone: "206-999-0909")
u.add_role :admin
u.save!

u = User.new(
  email: "librarian@example.com",
  password: "password",
  password_confirmation: "password",
  name: "Dewey Decimeowl",
  address: "99 SoftPaws Ln, Seattle, WA 98122",
  phone: "206-999-0909")
u.add_role :librarian
u.save!

u = User.new(
  email:  "user@example.com",
  password: "password",
  password_confirmation: "password",
  preferred_first_name: "Murray",
  name: "Marie Purrie",
  address: "99 SoftPaws Ln, Seattle, WA 98122",
  phone: "206-999-0909")
u.save!

l = Loan.new(
  user_id: User.last.id,
  book_id: Book.first.id)
l.save!(validate: false)

contributions = Contribution.create([{ name: "Author" },
                                     { name: "Illustrator" },
                                     { name: "Photographer" },
                                     { name: "Editor" },
                                     { name: "Foreword" }])
