source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.0.3'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'devise'
gem 'cancan'
gem 'rolify'
gem 'figaro'


group :production do
  gem 'pg'
  gem 'rails_12factor'
end 

group :development, :test do 
  gem 'rspec-rails'
  gem 'sqlite3'
end 

group :test do
    gem 'database_cleaner', '~> 1.3.0'
    gem 'capybara'
    gem 'selenium-webdriver'
    gem 'shoulda-matchers'
    gem 'factory_girl_rails', '~> 4.0'
    gem 'simplecov', '~> 0.9.0', :require => false
end

group :doc do
  gem 'sdoc', require: false
end
