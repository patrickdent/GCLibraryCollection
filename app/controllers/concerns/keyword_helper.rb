module KeywordHelper
  def keyword_params
    params.require(:keyword).permit(:name, :id)
  end 
end
