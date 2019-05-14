Pshr::Engine.routes.draw do
  # mount Shrine.upload_endpoint(:cache) => 'endpoint'
  mount Tus::Server => "/files"
end
