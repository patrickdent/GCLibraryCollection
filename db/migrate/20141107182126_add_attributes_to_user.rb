class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :notes, :text
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :sort_by, :string
    add_column :users, :address, :text
    add_column :users, :identification, :string
    add_column :users, :do_not_lend, :boolean
  end
end
