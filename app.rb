#!/usr/bin/env ruby

require_relative 'classes/application'
require 'date'

def date_params
  return [Date.today.to_s] if ARGF.argv.empty?
  # the contents of ARGF.argv need validation
  start_date, end_date = ARGF.argv
  [start_date, end_date].compact.sort
end

def main
  # if APP_ENV hasn't been set yet, set it to 'dev'
  ENV['APP_ENV'] ||= 'dev'
  # for now, ENV['APP_ENV'] is only allowed to be 'dev' or 'prod'
  unless ['dev', 'prod'].include?(ENV['APP_ENV'])
    raise(StandardError, 'Please run the app in one of these environments: dev, prod.')
  end

  app = Application.new(date_params)
  app.run

rescue StandardError => e
  puts e.message
end

main
