class RenameImportsToUploads < ActiveRecord::Migration
  def change
    rename_table :book_imports, :book_uploads
  end
end
