PushFlashBang::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  root :to => "info#about"

  match 'info/check_style' => 'info#check_style'
  match 'info/about' => 'info#about'

  resources :users, :as => "user" 

  resources :deck, :as => "deck" do
    member do
      post 'create', :as => 'create'
      get 'show', :as => 'show'
      get 'learn', :as => 'learn'
      get 'toggle_share', :as => 'toggle_share'
      get 'due_count'
      get 'upcoming'
    end
    
    resources :card do
      member do
        post 'review'
        get 'learn'
        get 'is_new'
      end
    end

    resource :chapter do
      member do
        get 'show', :as => 'show'
        get 'advance', :as => 'advance'
      end
    end
  end
end