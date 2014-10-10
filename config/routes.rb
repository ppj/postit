PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  resources :posts, except: [:destroy] do
    member do
      post 'vote'
      delete 'vote/destroy', to: 'posts#vote_destroy'
    end

    resources :comments, only: [:create] do
      member do
        post 'vote'
        delete 'vote/destroy', to: 'comments#vote_destroy'
      end
    end

  end

  resources :categories, only: [:show, :new, :create ]

  get '/register', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update]

  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get  '/logout', to: 'sessions#destroy'

end
