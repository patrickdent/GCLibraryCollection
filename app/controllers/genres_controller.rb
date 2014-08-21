class GenresController < ApplicationController
  def index
    @genres = Genre.all
  end

  def show
    @genre = Genre.find(params[:id])
  end

  def new 
    @genre = Genre.new
    @genres = Genre.all
  end 

  def create 
    @genre = Genre.new(genre_params)
    if @genre.save 
      flash[:notice] = "Genre added"
      redirect_to new_genre_path
    else
      flash[:alert] = "Genre failed to save"
      redirect_to new_genre_path
    end 
  end 

  private
  def genre_params
    params.require(:genre).permit(:name, :id)
  end 
end
