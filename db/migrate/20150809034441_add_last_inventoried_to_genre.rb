class AddLastInventoriedToGenre < ActiveRecord::Migration
  def change
    add_column :genres, :last_inventoried, :datetime
  end
end
