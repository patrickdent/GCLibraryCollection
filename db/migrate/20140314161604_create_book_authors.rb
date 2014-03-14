class CreateBookAuthors < ActiveRecord::Migration
  def change
    create_table :book_authors do |t|
      t.belongs_to :book
      t.belongs_to :author

      t.timestamps
    end
  end
end
