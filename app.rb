#!/usr/bin/env ruby

require_relative 'classes/application'

def main
  # if APP_ENV hasn't been set yet, set it to 'dev'
  ENV['APP_ENV'] ||= 'dev'
  # APP_ENV is only allowed to be 'dev' or 'prod'
  unless ['dev', 'prod'].include?(ENV['APP_ENV'])
    raise(StandardError, 'Unpermitted environment')
  end

  app = Application.new
  app.run

rescue StandardError => e
  puts e.message
end

main
