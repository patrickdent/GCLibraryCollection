module BookUploadsHelper

  def book_uploads_params
    params.require(:book_upload).permit(:file, :genre)
  end
  

end
