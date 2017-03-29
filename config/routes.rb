Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'website/home#index'

  namespace :admin do

  	get   '/dashboard',         to: "dashboard#index",  as:   :dashboard
  	
  	resources :base do
  	end

    resources :enquiries do
  		member do
        	put :update_status, as:  :update_status
      	end
    end

    resources :testimonials do
  		member do
    		put :update_status, as:  :update_status
        	put :mark_as_featured, as:  :mark_as_featured
        	put :remove_from_featured, as:  :remove_from_featured
      	end
    end

    resources :teams do
      	member do
        	put :update_status, as:  :update_status
      	end
    end

    resources :events do
      	member do
        	put :update_status, as:  :update_status
    		put :mark_as_featured, as:  :mark_as_featured
        	put :remove_from_featured, as:  :remove_from_featured
      	end
    end

    resources :brands do
      	member do
        	put :update_status, as:  :update_status
    		put :mark_as_featured, as:  :mark_as_featured
        	put :remove_from_featured, as:  :remove_from_featured
      	end
    end

    resources :users do
      	member do
        	put :masquerade, as: :masquerade
        	put :update_status, as:  :update_status
        	put :make_admin, as:  :make_admin
        	put :make_super_admin, as:  :make_super_admin
        	put :remove_admin, as:  :remove_admin
        	put :remove_super_admin, as:  :remove_super_admin
      	end
    end

    resources :categories do
      member do
        put :make_parent, as:  :make_parent
        put :update_status, as:  :update_status
        put :mark_as_featured, as:  :mark_as_featured
        put :remove_from_featured, as:  :remove_from_featured
      end
    end

    resources :products do
      member do
        put :update_status, as:  :update_status
        put :mark_as_featured, as:  :mark_as_featured
        put :remove_from_featured, as:  :remove_from_featured
      end
    end

  end


  get  '/sign_in',                    to: "sessions#sign_in",               as: :sign_in
  post '/create_session',             to: "sessions#create_session",        as: :create_session
  get  '/forgot_password_form',       to: "sessions#forgot_password_form",  as: :forgot_password_form

  # Logout Url
  delete  '/sign_out' ,               to: "sessions#sign_out",  as:  :sign_out


end
