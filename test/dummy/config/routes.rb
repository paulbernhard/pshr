Rails.application.routes.draw do
  mount Pshr::Engine => "/pshr"

  resources :posts

  pshr_for :uploads, controller: "pshr/uploads", resource: "Upload"
  pshr_for :custom_uploads

  root to: 'posts#index'
end
