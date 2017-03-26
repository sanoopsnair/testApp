Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do

  	get   '/dashboard',         to: "dashboard#index",  as:   :dashboard
  	
  	resources :base do
  	end

  end


  get  '/sign_in',                    to: "sessions#sign_in",               as: :sign_in
  post '/create_session',             to: "sessions#create_session",        as: :create_session
  get  '/forgot_password_form',       to: "sessions#forgot_password_form",  as: :forgot_password_form



end
