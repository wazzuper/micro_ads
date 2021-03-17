# frozen_string_literal: true

class AdSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title, :description, :city, :lat, :lon
end
