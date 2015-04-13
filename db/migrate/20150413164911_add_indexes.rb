class AddIndexes < ActiveRecord::Migration
  def change
    add_index :users, :email
    add_index :users, :name
    add_index :users, :username
    add_index :users, :preferred_first_name

    add_index :authors, :name

    add_index :book_keywords, :book_id
    add_index :book_keywords, :keyword_id

    add_index :book_authors, :book_id
    add_index :book_authors, :author_id

    add_index :books, :genre_id
    add_index :books, :isbn
    add_index :books, :title
    add_index :books, :location

    add_index :loans, :book_id
    add_index :loans, :user_id

    add_index :genres, :name

    add_index :keywords, :name
  end
end
