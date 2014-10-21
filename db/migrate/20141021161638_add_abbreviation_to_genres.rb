class AddAbbreviationToGenres < ActiveRecord::Migration
  def change
    add_column :genres, :abbreviation, :string
  end
end
