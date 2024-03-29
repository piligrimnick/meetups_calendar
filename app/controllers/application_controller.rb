class ApplicationController < ActionController::Base
  include Dry::Monads[:result]

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!

  protected

  # todo: move to parametersanitizer
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :username,
      :name,
      :middle_name,
      :last_name
    ])
  end
end
