# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:ads) do
      primary_key :id
      Integer :user_id, null: false
      String :title, null: false
      Text :description, null: false
      String :city, null: false
      Float :lat
      Float :lon
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
