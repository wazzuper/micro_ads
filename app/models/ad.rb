# frozen_string_literal: true

Sequel.connect(
  adapter: :postgres, database: 'icro_ads_db', host: 'localhost', user: 'micro_ads_user'
)

class Ad < Sequel::Model
  FIELDS = %i[title description city].freeze

  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  def validate
    super
    validates_presence(FIELDS)
  end
end
