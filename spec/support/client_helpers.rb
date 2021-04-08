# frozen_string_literal: true

module ClientHelpers
  def connection
    Faraday.new do |connection|
      connection.request :json
      connection.response :json, content_type: /\bjson$/
      connection.adapter :test, stubs
    end
  end

  def stubs
    @stubs ||= Faraday::Adapter::Test::Stubs.new
  end
end
