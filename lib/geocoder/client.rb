# frozen_string_literal: true

require 'dry/initializer'
require_relative 'api'

module Geocoder
  class Client
    extend Dry::Initializer[undifined: false]
    include Api

    option :queue, default: -> { create_queue }

    # option :url, default: -> { 'http://localhost:3333' }
    # option :connection, default: -> { build_connection }

    private

    # def build_connection
    #   Faraday.new(url) do |connection|
    #     connection.request :json
    #     connection.response :json, content_type: /\bjson$/
    #     connection.adapter Faraday.default_adapter
    #   end
    # end

    def create_queue
      channel = RabbitMq.channel
      channel.queue('geocoding', durable: true)
    end

    def publish(payload, opts = {})
      # @queue.publish == default_exchange
      @queue.publish(payload, opts.merge(persistent: true, app_id: 'ads'))
    end
  end
end
