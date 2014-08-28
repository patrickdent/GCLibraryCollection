class AddContributionToBookAuthor < ActiveRecord::Migration
  def change
    add_column :book_authors, :contribution_id, :integer
  end
end
