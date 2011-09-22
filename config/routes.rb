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

      put 'start_editing'
      put 'stop_editing'
      get 'flash_messages'
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
    collection do
      get 'user_languages'
      get 'remaining_languages'
    end

    resources :sets do
      collection do
        get 'user_sets'
      end

      member do
        get 'review'
        get 'next_chapter'
        post 'advance_chapter'
        get 'completed'
        put 'set_goal'
        put 'unset_goal'
        get 'user_goals'
        get 'due_count'
      end

      resources :terms do
        member do
          get 'first_review'
          get 'review'
          post 'record_review'
          post 'record_first_review'
        end
      end
    end
  end

  resources :sets do
    member do
      post 'add_set_name'
      delete 'delete_set_name'
      get 'user_goals'
      get 'show_chapter'
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
      get 'add_translation'
      post 'select'
      get 'search'
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