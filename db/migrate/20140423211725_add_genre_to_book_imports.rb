class AddGenreToBookImports < ActiveRecord::Migration
  def change
    add_column :book_imports, :genre, :string
  end
end
