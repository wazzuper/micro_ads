# frozen_string_literal: true

module Geocoder
  module Http
    module Api
      def geocode(city)
        response = connection.get('geocode')

        JSON.parse(response.body).dig('data') if response.success?
      end
    end
  end
end
