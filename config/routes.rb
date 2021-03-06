SampleApp::Application.routes.draw do
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  root to: 'static_pages#home'

  match  'signup',  to: 'users#new'
  match  'signin',  to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  match 'about',   to: 'static_pages#about'
  match 'contact', to: 'static_pages#contact'
  match 'help',    to: 'static_pages#help'
end
