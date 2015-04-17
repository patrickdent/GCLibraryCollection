class AddMissingToBooks < ActiveRecord::Migration
  def change
    add_column :books, :missing, :boolean, default: false
  end
end
