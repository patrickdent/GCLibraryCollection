class RemoveSelectedFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :selected, :boolean
  end
end
