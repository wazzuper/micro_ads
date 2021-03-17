# frozen_string_literal: true

require 'bundler'
Bundler.require

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  require File.join(root, '/config/autoload.rb')
end

before { content_type :json }

get '/ads' do
  ads = Ad.reverse_order(:updated_at).all

  status :ok
  AdSerializer.new(ads).serialized_json
end

post '/ads' do
  fake_user_id = 123
  result = Ads::CreateService.call(params: params.merge(user_id: fake_user_id))

  if result.success?
    status :created
    AdSerializer.new(result.ad).serialized_json
  else
    status :unprocessable_entity
    error_response(result.ad).to_json
  end
end

private

def error_response(error_messages)
  case error_messages
  when Sequel::Model
    ErrorSerializer.from_model(error_messages)
  else
    ErrorSerializer.from_messages(error_messages)
  end
end
