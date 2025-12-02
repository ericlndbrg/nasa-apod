# frozen_string_literal: true

def run_app
  require_relative 'classes/app'
  app = App.new
  app.run
rescue => e
  puts "ERROR! #{e.message}."
else
  puts "Successfully downloaded APOD for #{app.date}"
end

run_app
