class ReportsController < ApplicationController

  def dashboard
  end

  def build_report
    if params[:report] == "book-popularity"
      @books = Book.all if params[:genre].empty? || params[:genre] == 'all'
      @books ||= Book.where(genre_id: params[:genre])
      @books.reject!{|b| b.loans.count < 1}
      @report_title = "Book Popularity"
      @report_description = "These are all the books that have had any loans during the specified time period (currently since the beginning of time)."
    end
    if @books
      render "view_report.html.erb"
    else
      render json: {status: :error}
    end
  end

  def view_report
  end

end