Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "games#new"

  resources :games, only: [:new, :show, :create], param: :channel do
    member do
      post :start
      post :answer
      post :continue
      post :finish
      post :new_round
    end

    resources :invitations, only: [:index, :create]
  end
end
