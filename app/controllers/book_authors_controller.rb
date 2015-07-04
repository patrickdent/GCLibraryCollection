class BookAuthorsController < ApplicationController
  include UserRoleHelper

  before_filter :authenticate_user!
  before_filter :is_librarian?

  def add_author
    @book_author = BookAuthor.new
  end

private
  def book_author_params
    params.require(:book_author).permit(:contribution_id, :author_id, :book_id, :primary)
  end
end