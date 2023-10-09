# frozen_string_literal: true

# app/channels/application_cable/channel.rb

# The Channel class in ApplicationCable module is responsible for defining ApplicationCable channels.
# This class serves as a base class for creating custom ActionCable channels.

module ApplicationCable
  class Channel < ActionCable::Channel::Base
  end
end
