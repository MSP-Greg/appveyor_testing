# frozen_string_literal: true
# encoding: UTF-8

# Copyright (C) 2017 MSP-Greg

module TestEncoding
class << self
  def run
    enc = ARGV[0]
puts "Encoding #{enc}"
    case enc
    when 'utf-8'
      d = "\u2015".dup.force_encoding 'utf-8'
    when 'Windows-1252'
      d = 151.chr
    end
    puts d * 30
    
  end
end
end
TestEncoding.run