class AddFieldsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :notable, :boolean
    add_column :books, :keep_multiple, :boolean
  end
end
