Rails.application.routes.draw do
  root "flights#index"
  get "/flights", to: "flights#index"
  get 'bookings/new'
  get 'bookings/list', to:  "bookings#list_all"
  
  resources :bookings
  resources :flights
end
