Rails.application.routes.draw do
  devise_for :users

  resource :dashboard, only: :show, controller: "dashboard"

  resources :posts, except: [ :index ] do
    collection do
      get :published
      get :drafts
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#show"
end
