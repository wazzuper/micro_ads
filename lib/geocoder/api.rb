# frozen_string_literal: true

module Geocoder
  module Api
    # def geocode(city)
    #   response = connection.get('geocode')

    #   JSON.parse(response.body).dig('data') if response.success?
    # end

    def geocode_later(ad)
      payload = { id: ad.id, city: ad.city }.to_json
      publish(payload, type: 'geocode')
    end
  end
end
