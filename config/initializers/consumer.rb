# frozen_string_literal: true

channel = RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('ads', durable: true)

# aknowledge
queue.subscribe do |delivery_info, properties, payload|
  payload = JSON(payload)
  lat, lon = payload['coordinates']

  Ads::UpdateService.call(payload['id'], lat: lat, lon: lon)

  exchange.publish(
    '',
    routing_key: properties.reply_to,
    correlation_id: properties[:correlation_id]
  )
end
