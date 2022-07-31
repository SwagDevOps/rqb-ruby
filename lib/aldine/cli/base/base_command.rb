# frozen_string_literal: true

require_relative '../app'

# Base command.
#
# @abstract
class Aldine::Cli::Base::BaseCommand < Aldine::Cli::Command
  autoload(:Pathname, 'pathname')

  class << self
    protected

    def inherited(subclass, &block)
      super(subclass).then { block&.call(subclass) }
    end
  end

  protected

  # Returns the operating system's temporary file path.
  #
  # @return [Pathname]
  def tmpdir
    lambda do
      require 'tmpdir'

      Dir.tmpdir
    end.yield_self do |tmp|
      Pathname.new(ENV.fetch('TMPDIR', tmp.call)).expand_path
    end
  end
end
