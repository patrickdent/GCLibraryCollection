class DocumentGeneratorController < ApplicationController

  def new_report
    d = DocumentGenerator.new(:label)
    subjects = Book.where(selected: true)
    d.generate_document(subjects)

    send_file("collection_reports/label.pdf")
  end
end