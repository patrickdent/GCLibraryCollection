class ReportsController < ApplicationController

  def dashboard
    @books = Book.limit(10) #placeholder for real logic
  end

  def build_report
    puts params
    if params[:report] == "book_popularity"
      @books = Book.where(genre_id: params[:genre]) unless params[:genre].empty?
      @books = Book.all if params[:genre].empty?
    end
    if @books
      render json: @books.as_json(include: :loan_count)
    else
      render json: {status: :error}
    end
  end

end