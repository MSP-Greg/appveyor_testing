# frozen_string_literal: true

DASH = 8212.chr(Encoding::UTF_8)
puts "\n#{DASH * 65} #{ARGV[0]}"

re_txt = " \u2001\u2002\u2003\u2008\u2009\u200A "
puts "#{re_txt[/(\t|\p{Zs})+/].length} = 6 uni + 2 spaces"

re_txt = "\n\u2029\r\n"
puts "#{re_txt[/(\n|\r\n?|\p{Zl}|\p{Zp})+/].length} = 1 paragraph separator + 3 [\\r\\n]"
