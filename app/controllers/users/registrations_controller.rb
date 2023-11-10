# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    protected

    def after_update_path_for(resource)
      user_show_path(resource.nickname)
    end
  end
end
