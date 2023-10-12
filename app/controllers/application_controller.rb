# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  user_signed_in?
  current_user
  user_session
  root to: 'home#index'
end
