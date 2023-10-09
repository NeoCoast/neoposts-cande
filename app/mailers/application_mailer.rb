# frozen_string_literal: true

# app/mailers/application_mailer.rb

# ApplicationMailer is responsible for sending email notifications.

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
