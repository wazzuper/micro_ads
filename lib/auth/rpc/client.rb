# frozen_string_literal: true

require 'securerandom'
require 'dry/initializer'
require_relative 'api'

module Auth
  module Rpc
    class Client
      extend Dry::Initializer[undifined: false]
      include Api

      attr_reader :auth_payload

      option :queue, default: -> { create_queue }
      option :lock, default: -> { Mutex.new }
      option :condition, default: -> { ConditionVariable.new }

      def self.fetch
        Thread.current['auth.rpc_client'] ||= new.start
      end

      def start
        queue.subscribe do |delivery_info, properties, payload|
          if properties[:correlation_id] == @correlation_id
            @auth_payload = payload

            lock.synchronize { condition.signal }
          end
        end

        self
      end

      private

      def create_queue
        channel = RabbitMq.channel
        channel.queue('authentication', durable: true)
      end

      def publish(payload, opts = {})
        @correlation_id = SecureRandom.uuid

        lock.synchronize do
          queue.publish(
            payload,
            opts.merge(
              persistent: true,
              app_id: 'ads',
              reply_to: queue.name,
              correlation_id: @correlation_id
            )
          )

          condition.wait(lock)
        end

        auth_payload
      end
    end
  end
end
