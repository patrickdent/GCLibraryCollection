class ReportsController < ApplicationController

  def dashboard
    @books ||= [] #placeholder for real logic
  end

  def build_report
    if params[:report] == "book-popularity"
      @books = Book.where(genre_id: params[:genre]) unless params[:genre].empty?
      @books = Book.all if params[:genre].empty?
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