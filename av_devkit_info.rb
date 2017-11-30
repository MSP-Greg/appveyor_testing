# frozen_string_literal: true

module DevKitPath
  BASEPATH = ENV['PATH'].split(File::PATH_SEPARATOR)
  DASH = 8212.chr(Encoding::UTF_8)
  WIDTH = 70
  require 'devkit'

  def self.run
    dev_kit_ruby = (ENV['PATH'].split(File::PATH_SEPARATOR) - BASEPATH).sort
    puts " #{RbConfig::TOPDIR[/[^\/]+$/]}".rjust(WIDTH + 11, DASH)
    puts RUBY_DESCRIPTION
    puts "#{' DevKit paths'.rjust(WIDTH, DASH)}\n    #{dev_kit_ruby.join("\n    ")}"
    puts
    if (t = `make --version`)
      puts "#{' make'.rjust(WIDTH, DASH)}"
      puts t.split(/\r?\n/)[0..1].join("\n")
    end
    if (t = `gcc --version`)
      puts "#{' gcc'.rjust(WIDTH, DASH)}"
      puts t.split(/\r?\n/)[0..1].join("\n")
    end
    puts
  end
end
DevKitPath.run
exit 0
