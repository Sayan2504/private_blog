Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  resource :dashboard, only: :show, controller: "dashboard"
  resource :about, only: :show, controller: "about"

  # Singular: you only ever look at your own. Editing lives on Devise's
  # registration form at /users/edit, which this page links to.
  resource :account, only: :show, controller: "accounts"
  resources :authors, only: :show
  resources :bookmarks, only: %i[ index create destroy ]
  resources :follows, only: %i[ create destroy ]
  resources :notifications, only: :index
  get "search", to: "search#index", as: :search
  get "sitemap", to: "sitemaps#show", defaults: { format: :xml }, as: :sitemap

  resources :posts, except: [ :index ] do
    resource :reaction, only: :create
    resources :comments, only: %i[ create destroy ]
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
