class UserUpload < ActiveRecord::Base

  require 'csv'

  def save
    @new_users = Array.new
    if uploaded_users.each { |i| make_user(i) }
      @new_users
    else
      uploaded_users.each_with_index do |user, index|
        user.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def uploaded_users
    @uploaded_users ||= load_uploaded_users
  end

  def load_uploaded_users
    unassigned_data = open_spreadsheet
    unassigned_data[0].each { |col| col = col.downcase! }
    headers = unassigned_data.delete_at(0)
    users = unassigned_data.map! { |user| Hash[headers.zip(user)] }
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then CSV.read(file.path)
    when ".txt" then CSV.read(file.path, encoding: "bom|utf-8")
    # when ".xls" then Excel.new(file.path, nil, :ignore)
    # when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else raise InvalidFileError
    end
  end

  def make_user(user_data)

    return if User.find_by_email(user_data["e-mail"])
    if user_data["e-mail"]
      user = User.create( name: user_data["name"],
                          address: user_data["address"],
                          email: user_data["e-mail"],
                          phone: user_data["phone"],
                          password: "password" )
    else
      user = User.create( name: user_data["name"],
                    address: user_data["address"],
                    username: user_data["name"].delete(" "),
                    phone: user_data["phone"],
                    password: "password" )
    end
    @new_users << user
  end

  def self.import_requirements?(params)
    params.has_key?(:user_upload) && params[:user_upload].has_key?(:file) && params[:user_upload][:file] != nil
  end

  class InvalidFileError < RuntimeError
  end
end
