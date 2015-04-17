class DocumentGeneratorController < ApplicationController

  def new_report
    handler = DocumentGenerator.new(params[:type].to_sym)
    
    subjects = params[:subjects]
    handler.generate_document(subjects)

    send_file("collection_reports/#{params[:type]}.pdf")
  end
end