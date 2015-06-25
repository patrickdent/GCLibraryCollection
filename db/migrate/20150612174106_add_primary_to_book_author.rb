class AddPrimaryToBookAuthor < ActiveRecord::Migration
  def change
    add_column :book_authors, :primary, :boolean, default: false
  end
end
