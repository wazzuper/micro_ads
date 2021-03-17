# frozen_string_literal: true

module Ads
  class CreateService
    prepend BaseService

    option :params

    attr_reader :ad

    def call
      @ad = Ad.new(params)

      return fail!(@ad.errors) unless @ad.valid?

      @ad.save
    end
  end
end
