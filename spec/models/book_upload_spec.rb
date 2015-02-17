require 'spec_helper'

describe BookUpload do 

  let(:genre) { create(:genre) }

  before do
    @good_file = File.new(Rails.root + 'spec/fixtures/files/book_uploads_good_file.txt')
    @good_upload = BookUpload.new( { file: ActionDispatch::Http::UploadedFile.new(tempfile: @good_file, filename: File.basename(@good_file)), genre: genre } )
    @good_file.close
    @wrong_type_file = File.new(Rails.root + 'spec/models/book_upload_spec.rb')
    @wrong_type_upload = BookUpload.new( { file: ActionDispatch::Http::UploadedFile.new(tempfile: @wrong_type_file, filename: File.basename(@wrong_type_file)), genre: genre } )
    @wrong_type_file.close
  end

  describe 'open spreadsheet' do

    context 'with wrong file type' do
  
      it 'raises error' do
        expect{@wrong_type_upload.open_spreadsheet}.to raise_error(BookUpload::InvalidFileError)
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
        expect(@good_upload.load_uploaded_data.first).to have_key("title")
      end
    end 
  end

  describe 'save' do

    context 'with good file' do

      it 'returns ids of created books' do
        expect(@good_upload.save.length).to eq 5
      end
    end 
  end
end