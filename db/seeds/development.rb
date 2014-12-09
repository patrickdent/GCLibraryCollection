genres = Genre.create([{ name: 'Whisker Grooming', abbreviation: 'WG'  }, 
                       { name: 'Comfortable Positions', abbreviation: 'CoPo'  }, 
                       { name: 'Ew, Gross', abbreviation: 'EGr'  }])

Genre.create(name: 'Unassigned', abbreviation: 'UA')

authors = Author.create([{ name: 'Chairman Meow' }, 
                         { name: 'Fluffy Faulkner'}, 
                         { name: 'B. Author' }, 
                         { name: 'Boots McNally'}])

books = Book.create([{ title: 'Kittles and Bits', genre: genres[0], isbn: 1234567890 }, 
                     { title: 'I Am Who Am I?', genre: genres[1], isbn: 1123456789 },
                     { title: 'The Sound and the Furry', genre: genres[0], isbn: 1112345678 },
                     { title: 'Meowtains', genre: genres[2], isbn: 1111234567 }])

keywords = Keyword.create([{ name: 'good' },
                           { name: 'bad' },
                           { name: 'furry'}])

@int = 0
books.each do |b|
  b.keywords << keywords[(@int += 1) % keywords.count]
  b.keywords << keywords[(@int += 1) % keywords.count]
end

@int = 0
authors.each do |a|
  a.books << books[(@int += 1) % books.count]
  a.books << books[(@int += 1) % books.count]
end

@int = 0
(1..100).each do |i|
  authors[@int % authors.count].books << 
                          Book.create(title: "Test Book #{i}", 
                                      genre: genres[(@int += 1) % genres.count])
end

u = User.new(
  email: "admin@example.com",
  password: 'password',
  name: "Ad Meownistrator")
u.add_role :admin
u.save!(:validate => false)

u = User.new(
  email: "librarian@example.com",
  password: 'password',
  name: "Dewey Decimeowl")
u.add_role :librarian
u.save!(:validate => false)

u = User.new(
  email:  "user@example.com",
  password: 'password',
  name: "Marie Purrie")
u.save!(:validate => false)

l = Loan.new(
  user_id: User.last.id,
  book_id: Book.first.id)
l.save!(validate: false)

contributions = Contribution.create([{ name: 'Author' },
                                     { name: 'Illustrator' },
                                     { name: 'Photographer' },
                                     { name: 'Editor' },
                                     { name: 'Foreword' }])
