Rails.application.routes.draw do
  resources :posts
  mount Pshr::Engine => "/pshr"
end
