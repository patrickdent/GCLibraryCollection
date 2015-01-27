require 'spec_helper'

describe UserUpload do 

  before do
    @good_file = File.new(Rails.root + 'spec/fixtures/files/user_upload_test.csv')
    @good_upload = UserUpload.new( { file: ActionDispatch::Http::UploadedFile.new(tempfile: @good_file, filename: File.basename(@good_file))} )
    @good_file.close
    @wrong_type_file = File.new(Rails.root + 'spec/models/book_upload_spec.rb')
    @wrong_type_upload = UserUpload.new( { file: ActionDispatch::Http::UploadedFile.new(tempfile: @wrong_type_file, filename: File.basename(@wrong_type_file))} )
    @wrong_type_file.close
    @bad_type_file = File.new(Rails.root + 'spec/fixtures/files/user_upload_test_bad.csv')
    @bad_type_upload = UserUpload.new( { file: ActionDispatch::Http::UploadedFile.new(tempfile: @bad_type_file, filename: File.basename(@bad_type_file))} )
    @bad_type_file.close
  end

  describe 'open spreadsheet' do

    context 'with wrong file type' do
  
      it 'raises error' do
        expect{@wrong_type_upload.open_spreadsheet}.to raise_error(UserUpload::InvalidFileError)
      end
    end

    context 'with good file' do

      it 'returns an array' do
        expect((@good_upload.open_spreadsheet).class).to eq Array
      end
    end 
  end

  describe 'load imported books' do

    context 'with good file' do

      it 'returns an array of hashes' do
        expect(@good_upload.load_uploaded_data.first).to have_key("name")
      end
    end 
  end

  describe 'save' do

    context 'with good file' do

      it 'returns ids of created books' do
        expect(@good_upload.save.length).to eq 2
      end
    end 
  end
end