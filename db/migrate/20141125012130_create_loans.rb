class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.belongs_to :user
      t.belongs_to :book
      t.date :start_date
      t.date :due_date
      t.date :returned_date
      t.integer :renewal_count

      t.timestamps
    end
  end
end
