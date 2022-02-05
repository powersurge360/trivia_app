Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "games#new"

  resources :games, only: [:new, :show, :create] do
    post :start, on: :member
    post :answer, on: :member
    post :next, on: :member
    post :finish, on: :member
  end
end
