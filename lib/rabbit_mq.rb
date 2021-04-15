# frozen_string_literal: true

module RabbitMq
  extend self

  @mutex = Mutex.new

  def connection
    @mutex.synchronize do
      @connection ||= Bunny.new.start
    end
  end

  def channel
    Thread.current[:rabbitmq_channel] ||= connection.create_channel
  end

  def consumer_channel
    return if !Settings.auth_client.rpc || !Settings.geocoder_client.rpc

    Thread.current[:rabbitmq_consumer_channel] ||=
      connection.create_channel(nil, Settings.rabbitmq.consumer_pool)
  end
end
