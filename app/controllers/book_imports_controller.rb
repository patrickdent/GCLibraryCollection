class BookImportsController < ApplicationController
  include BookImportsHelper
  require 'csv'

  def new
    @book_import = BookImport.new
  end

  def create  
     if BookImport.import_requirements?(params)
      @book_import = BookImport.new(book_imports_params)
      if @book_import.save
        flash[:notice] = "Import Succssful"
      else
        render "static_pages/home"
      end
    else
      flash[:notice] = "Please select a file."
      render "static_pages/home"
    end
  end
end