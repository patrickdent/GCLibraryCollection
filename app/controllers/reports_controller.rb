class ReportsController < ApplicationController

  def dashboard
  end

  def build_report
    set_date_range
    if params[:report] == "book-popularity"
      build_book_popularity
    elsif params[:report] == "unpopular-books"
      build_unpopular_books
    elsif params[:report] == "missing-books"
      build_missing_books
    end

    if @books
      render "view_report.html.erb"
    else
      flash[:error] = "No books match this query"
      redirect_to :back
    end
  end

  def view_report
  end

  private
  def set_date_range
    case params[:dates]
    when "last-week"
      @date_range = 1.week.ago.to_date..Date.today
    when "last-month"
      @date_range = 1.month.ago.to_date..Date.today
    when "last-year"
      @date_range = 1.year.ago.to_date..Date.today
    else
      @date_range = 100.year.ago.to_date..Date.today
    end
  end

  def build_book_popularity
    @genre_name = set_genre
    @books = set_books.sort_by{|b| b.loans.where(start_date: @date_range).count}
    @report_title = "Book Popularity"
    @report_description = "These are all the books for specified category with the count of loans they've had during specified time period."
  end

  def build_unpopular_books
    @genre_name = set_genre
    @books = set_books.reject!{|b| b.loans.where(start_date: @date_range).count >= 1}
    @report_title = "Books Never Checked Out"
    @report_description = "These are all the books that have not had any loans during the specified time period."
  end

  def build_missing_books
    @genre_name = set_genre
    @books = set_books.where(missing: true)
    @report_title = "Missing Books"
    @report_description = "These are all the books that have been marked as missing."
  end

  def set_books
    return Book.all unless @genre
    return @genre.books if @genre
  end

  def set_genre
    @genre = Genre.find_by(id: params[:genre])
    return "All Categroies" unless @genre
    return @genre.name if @genre
  end
end