# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
genres = Genre.create([{ name: 'Meowstory', abbreviation: 'Ms'  }, 
                       { name: 'Self Help', abbreviation: 'SH'  }, 
                       { name: 'Fur Facts', abbreviation: 'FF'  }])

#temp storage for books with no genre
Genre.create(name: 'Unassigned', abbreviation: 'UA')

authors = Author.create([{ name: 'Chairman Meow' }, 
                         { name: 'Fluffy Faulkner'}, 
                         { name: 'B. Author' }, 
                         { name: 'Boots McNally'}])

books = Book.create([{ title: 'Kittles and Bits', genre: genres[0] }, 
                     { title: 'I Am Who Am I?', genre: genres[1] },
                     { title: 'The Sound and the Furry', genre: genres[0] },
                     { title: 'Meowtains', genre: genres[2] }])

keywords = Keyword.create([{ name: 'good' },
                           { name: 'bad' },
                           { name: 'furry'}])

#assigns cute name books to cute name authors
@int = 0
authors.each do |a|
  BookAuthor.create(book: books[(@int += 1) % books.count], author: a)
end

#a bunch of extra test books assigned to authors
(1..4).each do |i|
  BookAuthor.create(author: authors[i % authors.count], 
                    book: Book.create(title: "Test Book #{i}", 
                                      genre: genres[i % genres.count]))
end

# an admin user 
u = User.new(
  email: "admin@example.com",
  password: 'password')
u.add_role :admin
u.save!(:validate => false)

# different contributions
contributions = Contribution.create([{ name: 'Author' },
                                     { name: 'Illustrator' },
                                     { name: 'Photographer' },
                                     { name: 'Editor' },
                                     { name: 'Foreword' }])

