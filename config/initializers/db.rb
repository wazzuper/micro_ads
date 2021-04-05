# frozen_string_literal: true

DB = Sequel.connect(Settings.db.to_h)

Sequel::Model.db.extension(:pagination)

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :validation_helpers

Sequel.default_timezone = :utc
