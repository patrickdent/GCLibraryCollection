class BookAuthorsController < ApplicationController
  include UserRoleHelper

  before_filter :authenticate_user!
  before_filter :is_librarian?

  def manage_contributions
    @book_authors = BookAuthor.where(id: params["subjects"])
  end

  def update_contributions
    book_author_ids = params[:book_author].keys
    failures = 0

    book_author_ids.each do |b|
      contribution_id = params[:book_author][b]["contribution_id"]
      if Contribution.find_by(id: contribution_id)
        failures += 1 unless BookAuthor.find(b).update(contribution_id: contribution_id)
      elsif contribution_id.blank?
        BookAuthor.find(b).update(contribution_id: nil)
      end
    end

    if failures > 0
      flash[:error] = failures.to_s + " Update(s) Failed"
    else
      flash[:notice] = "Update(s) Successful"
    end

    redirect_to :back
  end

private
  def book_author_params
    params.require(:book_author).permit(:contribution_id)
  end
end