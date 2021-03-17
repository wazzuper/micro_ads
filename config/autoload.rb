# frozen_string_literal: true

require 'sinatra/base'

DIRS = %w[config/*.rb app/services/*.rb app/**/*.rb].freeze

DIRS.each do |dir|
  Dir[File.join(App.root, dir)].sort.each do |file|
    next if file.include?('autoload')
    require file
  end
end
