Rails.application.routes.draw do
  devise_for :users

  resource :dashboard, only: :show, controller: "dashboard"
  resource :about, only: :show, controller: "about"

  resources :posts, except: [ :index ] do
    collection do
      # Public: every published post, by anyone. Signed-out readers land here.
      get :published
      # Signed-in only: everything *you* wrote. Published and drafts are two
      # tabs on that one page (?tab=drafts), not two routes — a draft is the
      # same post before it goes out, so it never needed a page of its own.
      get :mine
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#show"
end
