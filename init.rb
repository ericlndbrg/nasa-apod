#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'classes/app'
require 'byebug'

def main
  App.new(ARGF.argv).execute
end

main
