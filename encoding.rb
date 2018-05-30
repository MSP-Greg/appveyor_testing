# frozen_string_literal: true
# encoding: UTF-8

# Copyright (C) 2017 MSP-Greg

module TestEncoding
class << self
  def run
    d = "\u2015".dup.force_encoding 'utf-8'
    puts d * 30
    
    d = '─'
    puts d * 30
  end
end
end
TestEncoding.run