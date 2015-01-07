class UsersSortByToPreferredFirstName < ActiveRecord::Migration
  def change
    rename_column :users, :sort_by, :preferred_first_name
  end
end
