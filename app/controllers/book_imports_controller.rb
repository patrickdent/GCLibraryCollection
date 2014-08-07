class BookImportsController < ApplicationController
  include BookImportsHelper
  require 'csv'
  rescue_from BookImport::InvalidFileError, with: :invalid_file
  rescue_from CSV::MalformedCSVError, with: :invalid_file

  def new
    @book_import = BookImport.new
  end

  def create  
     if BookImport.import_requirements?(params)
      @book_import = BookImport.new(book_imports_params)
      if @book_import.save
        flash[:notice] = "Import Successful"
      # else
      #   render "static_pages/home"
      end
    else
      flash[:notice] = "Please select a file."
      render "static_pages/home"
    end
  end

  def invalid_file
    flash[:notice] = "Import Unsuccessful: Please Ensure That The File Is Formatted Correctly."
    redirect_to :back
  end
end
