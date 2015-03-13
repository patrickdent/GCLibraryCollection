class CreateUserUpload < ActiveRecord::Migration
  def change
    create_table :user_uploads do |t|
      t.string :file

      t.timestamps
    end
  end
end
