# frozen_string_literal: true

require_relative '../local'

# Shell related methods
module Local::Shell
  autoload(:FileUtils, 'fileutils')
  autoload(:Etc, 'etc')

  class << self
    def sh(*arguments)
      Shell::Command.new(arguments).call
    end

    def tty?
      ![$stdin, $stdout, $stdout].map(&:tty?).include?(false)
    end

    def fs
      FileUtils::Verbose
    end

    def user
      Etc.getpwnam(Etc.getlogin)
    end
  end
end
