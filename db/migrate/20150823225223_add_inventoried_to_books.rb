class AddInventoriedToBooks < ActiveRecord::Migration
  def change
    add_column :books, :inventoried, :boolean, default: false
  end
end
