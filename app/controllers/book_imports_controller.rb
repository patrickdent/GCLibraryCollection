class BookImportsController < ApplicationController
  include BookImportsHelper
  require 'csv'
  rescue_from BookImport::InvalidFileError, with: :invalid_file
  rescue_from CSV::MalformedCSVError, with: :invalid_file

  def new
    @book_import = BookImport.new
    @genre = Genre.new 
  end

  def create  
     if BookImport.import_requirements?(params)
      @book_import = BookImport.new(book_imports_params)
      genre = Genre.find_by(name: params[:book_import][:genre])
      if @book_import.save
        flash[:notice] = "Import successful"
        redirect_to genre_path(genre.id)
      else
        flash[:error] = "Import failed"
        redirect_to new_book_import_path
      end
    else
      flash[:error] = "Please select a file and genre"
      redirect_to new_book_import_path
    end
  end

  def invalid_file(msg)
    flash[:error] = "Import Unsuccessful: please upload a file with the correct file type and formatting."
    redirect_to :back
  end
end
