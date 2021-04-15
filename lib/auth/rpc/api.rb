# frozen_string_literal: true

module Auth
  module Rpc
    module Api
      def fetch_user_id(token)
        payload = { token: token }.to_json
        publish(payload, type: 'auth')
      end
    end
  end
end
