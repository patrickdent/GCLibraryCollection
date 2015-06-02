class BookAuthorsController < ApplicationController

  include UserRoleHelper
  include BookAuthorsHelper

  before_filter :authenticate_user!
  before_filter :is_librarian?

  def manage_contributions
    @book_authors = BookAuthor.where(id: params["subjects"])
  end 

  def update
    if BookAuthor.find(params["id"]).update(book_author_params)
      flash[:notice] = "Update Successful"
    else
      flash[:error] = "Update Unsuccessful"
    end
    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
  end
end