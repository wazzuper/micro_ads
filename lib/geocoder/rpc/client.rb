# frozen_string_literal: true

require 'dry/initializer'
require_relative 'api'

module Geocoder
  module Rpc
    class Client
      extend Dry::Initializer[undifined: false]
      include Api

      option :queue, default: -> { create_queue }

      private

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
end
