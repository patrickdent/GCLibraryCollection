class AddInStorageToBooks < ActiveRecord::Migration
  def change
    add_column :books, :in_storage, :boolean, default: false
  end
end
