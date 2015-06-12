class BookAuthorsController < ApplicationController
  include UserRoleHelper

  before_filter :authenticate_user!
  before_filter :is_librarian?

  def add_author
    @book_author = BookAuthor.create(book_id: params["book_id"])
  end

private
  def book_author_params
    params.require(:book_author).permit(:contribution_id)
  end
end