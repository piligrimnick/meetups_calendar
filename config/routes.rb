Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  scope module: :api, defaults: {format: :json}, path: "api" do
    scope module: :v1, constraints: Constraints::ApiConstraint.new(version: 1, default: true) do
    end
  end
end
