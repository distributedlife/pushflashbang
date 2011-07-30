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
        get 'cram'
      end
    end

    resources :chapters do
      member do
        get 'show', :as => 'show'
        get 'advance', :as => 'advance'
        get 'reveal', :as => 'reveal'
        get 'cram', :as => 'cram'
      end
    end
  end

  resources :languages do
    collection do
      get 'user'
      get 'select'
    end
    
    member do
      post 'learn'
      post 'unlearn'
    end
  end
  
  resources :terms do
    collection do
      post 'add_translation'
      post 'select'
      get 'select_for_set'
    end

    resources :translations do
      member do
        post 'attach_and_detach'
        post 'attach'
      end
      collection do
        post 'select'
      end
    end
  end

  resources :sets do
    member do
      post 'add_set_name'
      delete 'delete_set_name'

      put 'add_term'
      put 'remove_term'
      put 'set_goal'
      put 'unset_goal'

      post 'term_next_chapter'
      post 'term_prev_chapter'
      post 'term_next_position'
      post 'term_prev_position'
    end

    collection do
      get 'select'
    end
  end
end