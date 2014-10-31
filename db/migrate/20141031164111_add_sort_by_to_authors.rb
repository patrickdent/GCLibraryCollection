class AddSortByToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :sort_by, :string
  end
end
