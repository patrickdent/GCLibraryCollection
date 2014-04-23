module BookImportsHelper

  def book_imports_params
    params.require(:book_import).permit(:file)
  end
  

end
