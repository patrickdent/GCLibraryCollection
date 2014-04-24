class AddFurtherInfoToBooks < ActiveRecord::Migration
  def change
    add_column :books, :publisher, :string
    add_column :books, :publish_date, :string
    add_column :books, :publication_place, :string
  end
end
