LibraryCollection
=================

A public web interface for patrons to view and search a library collection.

Ruby 2.0.0

###After you pull from origin, run:
 - bundle install 
 - rake db:migrate
 - rake db:seed 
 - rails server


#v1
###public user can:

 - view library info on homepage 
 - browse collection by author
 - browse collection by genre
 - search collection by genre, author, or title 
 - contact librarians

###admin can:

 - log in to view admin dashboard 
 - upload a file (export from previous cataloguing system) of books to be entered into collection 


#v2

###admin can: 

 - manage collection with CRUD capabilities for all items
 - enter the ISBN of a new item and get details for it via scrape process


#v3 : Full library management app!

###public user can: 

 - see if a book is available to check out

###patron can:

 - log in to view their borrowing history 
 - put an available book on hold 

###librarian can:

 - log in to view librarian dashboard
 - create patron accounts (for borrowing & using the app)
 - check books in/out to patrons 
 - view borrowing history of collection items
 - view borrowing history of each patron 
 - generate reports from borrowing data 

###admin can: 

 - create librarian accounts

