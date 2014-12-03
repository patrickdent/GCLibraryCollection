class AddSelectedToBooks < ActiveRecord::Migration
  def change
    add_column :books, :selected, :boolean, default: false
  end
end
