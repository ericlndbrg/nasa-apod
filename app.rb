#!/usr/bin/env ruby

def main
  require_relative 'classes/application'
  app = Application.new
  app.run
end

main
