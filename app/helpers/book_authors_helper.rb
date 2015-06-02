module BookAuthorsHelper
  def book_author_params
    params.require(:book_author).permit(:contribution_id)
  end
end
