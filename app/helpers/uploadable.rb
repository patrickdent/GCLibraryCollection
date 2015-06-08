module Uploadable
  require 'csv'

  def save
    @new_objects = Array.new

    if uploaded_data.each { |i| make_object(i) }
      @new_objects
    else
      uploaded_data.each_with_index do |object, index|
        object.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def uploaded_data
    @uploaded_data ||= load_uploaded_data
  end

  def load_uploaded_data
    unassigned_data = open_spreadsheet
    unassigned_data[0].each { |col| col = col.downcase! }
    headers = unassigned_data.delete_at(0)
    data = unassigned_data.map! { |user| Hash[headers.zip(user)] }
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then CSV.read(file.path, encoding: "bom|utf-8")
    when ".txt" then CSV.read(file.path, encoding: "bom|utf-8")
    # when ".xls" then Excel.new(file.path, nil, :ignore)
    # when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else raise InvalidFileError
    end
  end

  def make_object
    #override this method in the model
  end

  class InvalidFileError < RuntimeError
  end
end