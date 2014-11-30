
#temp storage for books with no genre
Genre.create(name: 'Unassigned')

# an admin user 
u = User.new(
  email: "admin@example.com",
  password: 'password',
  username: "admin")
u.add_role :admin
u.save!(:validate => false)

# a librarian user 
u = User.new(
  email: "librarian@example.com",
  password: 'password',
  username: "librarian")
u.add_role :librarian
u.save!(:validate => false)
