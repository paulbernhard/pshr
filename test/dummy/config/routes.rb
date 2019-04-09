Rails.application.routes.draw do
  mount Pshr::Engine => "/pshr"

  resources :posts

  resources :uploads, controller: 'pshr/uploads',
                      defaults: { resource: 'Upload' },
                      only: [:create, :update, :destroy]

  resources :custom_uploads, controller: 'custom_uploads',
                      defaults: { resource: 'CustomUpload' },
                      only: [:create, :update, :destroy]
                      
  # TODO helper for Pshr routes
  root to: 'posts#index'
end
