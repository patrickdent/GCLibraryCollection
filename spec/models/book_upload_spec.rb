require 'spec_helper'

describe BookUpload do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  let(:genre) { create(:genre) }

  before do
    @good_file = File.new(Rails.root + 'spec/fixtures/files/book_uploads_good_file.txt')
    @good_upload = BookUpload.new( { file: ActionDispatch::Http::UploadedFile.new(tempfile: @good_file, filename: File.basename(@good_file)), genre: genre.id.to_s } )
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
        expect(@good_upload.save.length).to eq 3
      end

      it 'assigns genre to unassigned books' do
        create(:genre, name: 'Unassigned', abbreviation: 'UA') unless Genre.find_by_name("Unassigned")
        unassigned_count = Genre.find_by_name("Unassigned").books.count
        @good_upload.genre = nil
        @good_upload.save
        expect(Genre.find_by_name("Unassigned").books.count).to eq(unassigned_count + 2)
      end

      it 'creates and assigns given genre to books' do
        expect(Genre.find_by_name("DVD")).to eq(nil)
        @good_upload.genre = nil
        @good_upload.save
        expect(Genre.find_by_name("DVD").books.count).to eq(1)
      end

      it 'creates and assigns and author to books' do
        expect(Author.find_by_name("Example Author")).to eq(nil)
        @good_upload.save
        expect(Author.find_by_name("Example Author").books.count).to eq(1)
      end
    end
  end
end