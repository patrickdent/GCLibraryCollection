class AddFileToBookImports < ActiveRecord::Migration
  def change
    add_column :book_imports, :file, :string
  end
end
