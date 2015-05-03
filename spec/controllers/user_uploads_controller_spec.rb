require 'spec_helper'

describe UserUploadsController do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @user = create :user
    @admin = create :admin
  end

  after :all do
    DatabaseCleaner.clean
  end

  after :each do
    Warden.test_reset!
  end

  let(:good_file) { fixture_file_upload('files/user_upload_test.csv', 'text/xml') }
  let(:bad_file) { fixture_file_upload('files/user_upload_test_bad.csv', 'text/xml') }

  describe 'as non-admin' do

    before { sign_in @user }

    it 'redirects unauthorized users' do
      expect(get :new).to redirect_to(root_path)
      expect(post :create).to redirect_to(root_path)
      expect(get :uploaded_users).to redirect_to(root_path)
    end
  end

  describe 'as admin' do

    before { sign_in @admin }

    context 'without import requirements' do

      it 'redirects to new upload' do
        post :create, user_upload: { file: nil }
        expect(response).to redirect_to(new_user_upload_path)
      end

      it 'flashes error' do
        post :create, user_upload: { file: nil }
        expect(flash[:error]).to eq "please select a file"
      end
    end

    context 'with bad file' do

      before(:each) do
        request.env["HTTP_REFERER"] = new_user_upload_path
      end

      it 'redirects back' do
        post :create, user_upload: { file: bad_file }
        expect(response).to redirect_to(new_user_upload_path)
      end

      it 'flashes error' do
        post :create, user_upload: { file: bad_file }
        expect(flash[:error]).to eq "upload unsuccessful: please upload a file with the correct file type and formatting."
      end
    end

    context 'with good file' do

      it 'redirects to uploaded users' do
        post :create, user_upload: { file: good_file }
        expect(response).to redirect_to('/uploaded_users?new_users=2')
      end

      it 'flashes success' do
        post :create, user_upload: { file: good_file }
        expect(flash[:notice]).to eq "upload successful"
      end
    end
  end
end