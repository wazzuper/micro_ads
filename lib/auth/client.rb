# frozen_string_literal: true

require 'dry/initializer'
require_relative 'api'

module Auth
  class Client
    extend Dry::Initializer[undifined: false]
    include Api

    option :url, default: -> { 'http://localhost:2222/v1' }
    option :connection, default: -> { build_connection }

    private

    def build_connection
      Faraday.new(url) do |connection|
        connection.request :json
        connection.response :json, content_type: /\bjson$/
        connection.adapter Faraday.default_adapter
      end
    end
  end
end
