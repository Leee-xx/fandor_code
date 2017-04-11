Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :films, constraints: { format: 'json' } do
    member do
      patch 'rate'
    end
  end
end
