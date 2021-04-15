# frozen_string_literal: true

module Auth
  class Unauthorized < StandardError; end

  AUTH_TOKEN = %r{\ABearer (?<token>.+)\z}

  def user_id
    result =
      if Settings.auth_client.rpc
        rpc_client.fetch_user_id(matched_token)
      else
        http_client.auth(matched_token)
      end

    raise Unauthorized unless result

    Settings.auth_client.rpc ? JSON(result)['user_id'] : result
  end

  private

  def http_client
    @client ||= Auth::Http::Client.new
  end

  def rpc_client
    @client ||= Auth::Rpc::Client.fetch
  end

  def matched_token
    result = auth_header&.match(AUTH_TOKEN)

    return if result.blank?

    result[:token]
  end

  def auth_header
    request.env['HTTP_AUTHORIZATION']
  end
end
