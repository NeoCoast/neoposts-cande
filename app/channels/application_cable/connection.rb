# frozen_string_literal: true

# app/channels/application_cable/connection.rb

# The connection class in ApplicationCable module is responsible for defining ApplicationCable connections.
# This class serves as a base class for creating custom ActionCable connections.

module ApplicationCable
  class Connection < ActionCable::Connection::Base
  end
end
