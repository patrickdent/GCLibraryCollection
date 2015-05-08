module BooksHelper
  def book_params
    params.require(:book).permit!
  end
end
