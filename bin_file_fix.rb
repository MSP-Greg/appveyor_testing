# frozen_string_literal: true
# encoding: UTF-8

# removes all path info from files in bin folder
#
module BinFileFix

  require RbConfig unless defined? RbConfig

  # 32 or 64
  ARCH   = RbConfig::CONFIG["target_cpu"] == 'x64' ? '64' : '32'
  BINDIR = RbConfig::CONFIG['bindir'].encode('UTF-8')
  
  # Array of regex and strings for bin file cleanup
  # 1st element for full path ruby
  # 2nd element for odd path ruby seen in rake.bat
  # 3rd element for rubygems, which may just use "ruby.exe"
  CLEAN_INFO = [
    [ /^@"#{Regexp.escape(BINDIR.gsub("/", "\\"))}\\ruby\.exe"/u     , '@%~dp0ruby.exe'],
    [ /^@"\\#{Regexp.escape(ENV['RUBY_VERS_BASE'])}\\bin\\ruby.exe"/u, '@%~dp0ruby.exe'],
    [ /^@"ruby.exe"/u                                                , '@%~dp0ruby.exe'],
    [ /"#{Regexp.escape(BINDIR)}\/([^ "]+)"/u      , '%~dp0\1'],
    [ /^#!(\/usr\/bin\/env|\/mingw#{ARCH}\/bin\/)/u, '#!'     ],
    [ /\r/, '']
  ]

  def self.run
    Dir.chdir(BINDIR) { |d|
      `attrib -r /s /d`
      files = Dir.glob("*").reject { |fn| fn.end_with?('.dll', '.exe') || Dir.exist?(fn) }
      files.each { |fn|
        str = File.read(fn, mode: 'rb').encode('UTF-8')
        wr = nil
        CLEAN_INFO.each { |i| wr = str.gsub!(i[0], i[1]) ? true : wr }
        File.write(fn, str.encode('UTF-8'), mode: 'wb:UTF-8') if wr
      }
    }
  end
end
BinFileFix.run
