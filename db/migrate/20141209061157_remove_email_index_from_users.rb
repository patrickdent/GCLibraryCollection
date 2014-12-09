class RemoveEmailIndexFromUsers < ActiveRecord::Migration
  def change
    remove_index(:users, :name => 'index_users_on_email')
    remove_index(:users, :name => 'index_users_on_username')
  end
end
