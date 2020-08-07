Rails.application.routes.draw do
  get 'contact/list'
  root 'contact#list'
  resources :conversations, only: [:index, :create] do 
  	member do 
  		post 'new_message'
  	end
  end
  devise_for :users 
  mount ActionCable.server => "/cable"

  resources :messages, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
