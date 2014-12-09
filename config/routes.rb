LibraryCollection::Application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout" }, :controllers => {:registrations => "registrations"}
  resources :books
  resources :genres
  resources :authors
  resources :keywords
  resources :book_uploads, only: [:new, :create]
  resources :users, only: [ :update, :destroy, :edit, :show, :index ], path: 'manage_users'
  resources :loans, only: [ :show, :index, :new, :create ]

  get 'uploaded_books' => 'book_uploads#uploaded_books'
  get 'search' => 'search#search'
  get 'import' => 'search#import'
  post 'scrape' => 'search#scrape'
  post 'renew' => 'loans#renew'
  post 'return' => 'loans#return'
  post 'list' => 'books#list', defaults: {format: :json}
  get 'clear_list' => 'books#clear_list', defaults: {format: :js}
  get 'show_list' => 'books#show_list'

  get 'admin_dashboard' => 'static_pages#admin_dashboard'
  get 'styleguide' => 'static_pages#styleguide'
  
  root to: 'static_pages#home'
  
end
