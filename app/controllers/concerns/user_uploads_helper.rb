module UserUploadsHelper

  def user_uploads_params
    params.require(:user_upload).permit(:file)
  end
end
