class ReportsController < ApplicationController

  def dashboard
    @books = Book.limit(10) #placeholder for real logic
  end

end