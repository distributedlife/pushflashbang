PushFlashBang::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  root :to => "info#about"

  match 'info/check_style' => 'info#check_style'
  match 'info/about' => 'info#about'

  resources :users, :as => "user" do
    collection do
      resources :languages, :as => "user_languages" do
        member do
          post 'learn'
          post 'unlearn'
        end
      end
    end
  end

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
    resources :sets do
      member do
        get 'review'
        get 'next_chapter'
        get 'completed'
        put 'set_goal'
        put 'unset_goal'
      end

      resources :terms do
        member do
          get 'review'
        end
      end
    end
  end

  resources :sets do
    member do
      post 'add_set_name'
      delete 'delete_set_name'
    end
    
    resources :languages, :as => "set_language" do
      collection do
        get 'select'
      end
    end

    resources :terms, :as => "set_terms" do
      member do
        put 'add_to_set'
        put 'remove_from_set'
        post 'next_chapter'
        post 'prev_chapter'
        post 'next_position'
        post 'prev_position'
      end

      collection do
        get 'select_for_set'
      end
    end
  end
  
  resources :terms do
    collection do
      post 'add_translation'
      post 'select'
    end

    resources :sets, :as => "term_sets" do
      collection do
        get 'select'
      end
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

end