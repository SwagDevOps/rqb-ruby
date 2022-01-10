# frozen_string_literal: true

require_relative '../local'

# Shell related methods
module Rqb::Local::Shell
  autoload(:FileUtils, 'fileutils')
  autoload(:Etc, 'etc')
  autoload(:Pathname, 'pathname')

  class << self
    # @return [Process::Status]
    def sh(*arguments)
      ::Rqb::Shell::Command.new(arguments).call
    end

    # @return [Boolean]
    def tty?
      ![$stdin, $stdout, $stdout].map(&:tty?).include?(false)
    end

    # @return [Module<FileUtils>, Module<FileUtils::Verbose>]
    def fs
      FileUtils::Verbose
    end

    # @return [Struct]
    def user
      # noinspection RubyMismatchedReturnType
      Etc.getpwnam(Etc.getlogin)
    end

    # @return [Pathname]
    def pwd
      Pathname.pwd
    end
  end
end
