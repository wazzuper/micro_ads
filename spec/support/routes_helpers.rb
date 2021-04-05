# frozen_string_literal: true

module RoutesHelpers
  def app
    described_class
  end

  def response_body
    JSON(last_response.body)
  end
end
