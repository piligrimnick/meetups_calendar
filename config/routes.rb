Rails.application.routes.draw do
  devise_for :users
  root to: 'activities#index'

  resources :activities do
    collection do
      get :download_csv
    end
  end

  scope module: :api, defaults: {format: :json}, path: "api" do
    scope module: :v1, constraints: Constraints::ApiConstraint.new(version: 1, default: true) do
    end
  end
end
