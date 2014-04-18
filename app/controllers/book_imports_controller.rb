class BookImportsController < ApplicationController
  include BookImportsHelper
  require 'csv'

  def new
    @book_import = BookImport.new
  end

  def create

    if params.has_key?(:book_import)

      @book_import = BookImport.new(book_imports_params)
      if @book_import.save
        flash[:notice] = "Import Succssful"
      else
        render "static_pages/admin_home"
      end

    else

      flash[:notice] = "Please select a file."
      render "static_pages/admin_home"

    end
  end
end