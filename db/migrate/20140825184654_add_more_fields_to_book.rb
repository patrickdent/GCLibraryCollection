class AddMoreFieldsToBook < ActiveRecord::Migration
  def change
    add_column :books, :pages, :integer
    add_column :books, :location, :string
  end
end
