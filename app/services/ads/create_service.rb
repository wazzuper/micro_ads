# frozen_string_literal: true

module Ads
  class CreateService
    prepend BaseService

    param :ad do
      option :title
      option :description
      option :city
    end

    option :user_id

    attr_reader :ad

    def call
      @ad = ::Ad.new(new_values)

      return fail!(@ad.errors) unless @ad.valid?

      @ad.save
    end

    private

    def new_values
      values = ad.to_h.merge(user_id: user_id)

      return values if values["city"].blank?

      coordinates = client.geocode(values["city"])
      coordinates.present? ? values.merge(coordinates) : values
    end

    def client
      @client ||= Geocoder::Client.new
    end
  end
end
