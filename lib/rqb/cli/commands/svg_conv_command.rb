# frozen_string_literal: true

require_relative '../app'

# Convert svg to pdf
class Rqb::Cli::Commands::SvgConvCommand < Rqb::Cli::Base::BaseCommand
  parameter('SOURCE', 'filepath without extension', { attribute_name: :param_source })
  option('--[no-]debug', :flag, 'enable debug messages', { default: true })

  # @!method debug?
  #   Denotes debug is active
  #   @return [Boolean]

  # @!attribute [rw] param_source
  #   @return [String]

  def execute
    converter.call(input_file)
  end

  # Determines target file from parent param_file (which is probably not an actual file).
  #
  # @return [Pathname]
  def input_file
    Pathname.new(self.param_source).then do |given_file|
      if given_file.extname != '.svg' and Pathname.new("#{given_file}.svg").exist?
        given_file = "#{given_file}.svg"
      end

      Pathname.new(given_file).realpath
    end
  end

  protected

  # @return [Rqb::Cli::Commands::Shared::SvgConv]
  def converter
    Rqb::Cli::Commands::Shared::SvgConv.new(debug: debug?, tmpdir: tmpdir)
  end
end
