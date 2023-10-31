# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[email password password_confirmation nickname last_name first_name
                                               birthday avatar])

    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[email password password_confirmation nickname last_name first_name
                                               birthday avatar])
  end
end
