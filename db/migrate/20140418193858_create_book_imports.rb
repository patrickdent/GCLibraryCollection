class CreateBookImports < ActiveRecord::Migration
  def change
    create_table :book_imports do |t|

      t.timestamps
    end
  end
end
