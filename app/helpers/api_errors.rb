# frozen_string_literal: true

require 'sinatra/extension'

module ApiErrors
  extend Sinatra::Extension

  helpers do
    def errors_response(error_messages)
      errors = case error_messages
      when Sequel::Model
        ErrorSerializer.from_model(error_messages)
      else
        ErrorSerializer.from_messages(error_messages)
      end

      json errors
    end
  end

  error Sequel::NoMatchingRow do
    status 404
    errors_response 'not found'
  end

  error Sequel::UniqueConstraintViolation do
    status 422
    errors_response 'not uniqie'
  end

  error Validations::InvalidParams, KeyError do
    status 422
    errors_response 'missing parameters'
  end
end
