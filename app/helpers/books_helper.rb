module BooksHelper
  def book_params
    params.require(:book).permit(:title, :genre_id, author_ids: [])
  end
end
