Rails.application.routes.draw do
  mount Pshr::Engine => "/pshr"
  resources :posts
  resources :uploads, controller: 'pshr/uploads',
                      defaults: { resource: 'Upload' },
                      only: [:create, :update, :destroy]
  root to: 'posts#index'
end
