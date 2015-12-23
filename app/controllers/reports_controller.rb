class ReportsController < ApplicationController

  def dashboard
  end

  def build_report
    if params[:report] == "book-popularity"
      build_book_popularity
    elsif params[:report] == "unpopular-books"
      build_unpopular_books
    end
    if @books
      render "view_report.html.erb"
    else
      render json: {status: :error}
    end
  end

  def view_report
  end

  private
  def build_book_popularity
    @books = Book.all if params[:genre].empty? || params[:genre] == 'all'
    @books ||= Book.where(genre_id: params[:genre])
    @books.reject!{|b| b.loans.count < 1}
    @report_title = "Book Popularity"
    @report_description = "These are all the books that have had any loans during the specified time period (currently since the beginning of time)."
  end

  def build_unpopular_books
    @books = Book.all if params[:genre].empty? || params[:genre] == 'all'
    @books ||= Book.where(genre_id: params[:genre])
    @books.reject!{|b| b.loans.count >= 1}
    @report_title = "Books Never Checked Out"
    @report_description = "These are all the books that have not had any loans during the specified time period (currently since the beginning of time)."
  end

end