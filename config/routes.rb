Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api do
    scope :v1 do
      resource :login, only: [:create, :update]

      resource :profile, only: [:show, :update]

      resources :locations, only: [:create] do
        collection do
          get :latest
        end
      end
    end
  end
end
