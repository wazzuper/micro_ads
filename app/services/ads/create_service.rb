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
      @ad = ::Ad.new(ad.to_h.merge(user_id: user_id))

      return fail!(@ad.errors) unless @ad.valid?

      @ad.save
    end
  end
end
