Genre.create(name: "Unassigned", abbreviation: 'UA')

u = User.new(
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  username: "admin",
  preferred_first_name: "Adonis",
  name: "Ad Meownistrator",
  address: "99 SoftPaws Ln, Seattle, WA 98122",
  phone: "206-999-0909")
u.save
u.add_role :admin

u = User.new(
  email: "librarian@example.com",
  password: "password",
  password_confirmation: "password",
  username: "librarian",
  name: "Dewey Decimeowl",
  address: "99 SoftPaws Ln, Seattle, WA 98122",
  phone: "206-999-0909")
u.save
u.add_role :librarian

Genre.create(name: "Unassigned", abbreviation: "UA")