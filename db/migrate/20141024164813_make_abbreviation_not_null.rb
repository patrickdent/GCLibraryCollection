class MakeAbbreviationNotNull < ActiveRecord::Migration
  def change
    change_column :genres, :abbreviation, :string, null: false
  end
end
