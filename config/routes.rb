LibraryCollection::Application.routes.draw do
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  resources :books
  resources :genres
  resources :authors
  resources :keywords
  resources :book_imports, only: [:new, :create]

  get 'search' => 'search#search'
  get 'import' => 'search#import'
  post 'scrape' => 'search#scrape'

  get 'admin_dashboard' => 'static_pages#admin_dashboard'
  get 'styleguide' => 'static_pages#styleguide'
  
  root to: 'static_pages#home'
  
end
