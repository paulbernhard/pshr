Pshr::Engine.routes.draw do
  mount Pshr::FileUploader.upload_endpoint(:cache) => 'endpoint'
end
