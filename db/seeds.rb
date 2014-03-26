# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
genre = Genre.create([{ name: 'Meowstory'}])
authors = Author.create([{ name: 'Chairman Meow' }, { name: 'B. Author'}])
book = Book.create([{ title: 'Kittles and BIts', genre_id: 1}])
authors[0].books << book 