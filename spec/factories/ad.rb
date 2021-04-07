# frozen_string_literal: true

FactoryBot.define do
  factory :ad do
    title { 'Ad title' }
    description { 'Ad description' }
    city { 'City' }
    sequence(:user_id) { |i| i }
  end
end
