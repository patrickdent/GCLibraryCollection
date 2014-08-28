class CreateBookKeywords < ActiveRecord::Migration
  def change
    create_table :book_keywords do |t|
      t.belongs_to :book
      t.belongs_to :keyword

      t.timestamps
    end
  end
end
