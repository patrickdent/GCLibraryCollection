class AddAvailableAndCountToBooks < ActiveRecord::Migration
  def change
    add_column :books, :available, :boolean, default: true
    add_column :books, :count, :integer, default: 1 
  end
end
