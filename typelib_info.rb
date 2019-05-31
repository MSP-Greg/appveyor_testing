# frozen_string_literal: true

=begin
ruby C:\Greg\GitHub\testing-appveyor\typelib_info.rb
=end

require 'win32ole'

module TypelibInfo
class << self
  def run
    tlibs = WIN32OLE_TYPELIB.typelibs
    tlibs.sort_by!(&:name)
    tlibs.select! { |tl| /XML/ =~ tl.name }
    tlibs.each { |tl|
      puts tl.name
      cls = tl.ole_classes.map { |ole_cls| ole_cls.name }.sort.join "\n    "
      puts "    #{cls}"
    }
  end
end
end
TypelibInfo.run
