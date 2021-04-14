# frozen_string_literal: true

module Ads
  class UpdateService
    prepend BaseService

    param :id
    param :data
    param :ad, default: -> { Ad.first(id: id) }

    def call
      return fail!(I18n.t(:not_found, scope: 'services.ads.update_service')) if ad.blank?
      ad.update_fields(@data, %i[lat lon])
    end
  end
end
