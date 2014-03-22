# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
genres = Genre.create([{ name: 'Meowstory' }, 
                       { name: 'Self Help' }, 
                       { name: 'Fur Facts' }])

authors = Author.create([{ name: 'Chairmam Meow' }, 
                         { name: 'Fluffy Faulkner'}, 
                         { name: 'B. Author' }, 
                         { name: 'Boots McNally'}])

books = Book.create([{ title: 'Kittles and Bits', genre: genres[0] }, 
                     { title: 'I Am Who Am I?', genre: genres[1] },
                     { title: 'The Sound and the Furry', genre: genres[0] },
                     { title: 'Meowtains', genre: genres[2] }])

@int = 0

#assigns cute name books to cute name authors
authors.each do |a|
  a.books << books[(@int += 1) % 4]
end

@int = 0

#a bunch of extra test books assigned to authors
(1..100).each do |i|
  authors[@int % 4].books << Book.create(title: "Test Book #{i}", genre: genres[(@int += 1) % 3])
end
 