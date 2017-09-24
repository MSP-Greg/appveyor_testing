# frozen_string_literal: true

require 'open-uri'

desc = RUBY_DESCRIPTION.ljust(55)
begin
  temp = OpenURI.open_uri('https://raw.githubusercontent.com/gcc-mirror/gcc/master/config.guess')
  puts "#{desc} SSL Verified"
rescue => e
  puts "#{desc} SSL Failed #{e.message}"
end
