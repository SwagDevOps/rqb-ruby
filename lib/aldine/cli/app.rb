# frozen_string_literal: true

require_relative '../cli'

# Cli app based on top of clamp.
#
# @see https://github.com/mdub/clamp
class Aldine::Cli::App < ::Clamp::Command
  autoload(:Pathname, 'pathname')

  {
    Loader: 'loader',
  }.each { |k, v| autoload(k, "#{__dir__}/app/#{v}") }

  # Execute is triggered when no subcommands are found.
  #
  # Print an error message on STDERR and exit with an error status code.
  def execute
    warn('No commands implemented at the moment.')

    Errno::ENOTSUP::Errno.tap { |status| exit(status) }
  end

  class << self
    protected

    # @return [String]
    def invocation_path
      File.basename($PROGRAM_NAME)
    end

    # Get paths from where subcommands are loaded.
    #
    # @return [Array<Pathname>]
    def paths
      [
        Pathname.new(__dir__).join('commands')
      ]
    end

    def loader
      Loader.new(self.paths)
    end
  end

  # Load commands -------------------------------------------------------------
  loader.call { |name, info| subcommand(name, info.description, info.class_name) }
end
