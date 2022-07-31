# frozen_string_literal: true

require_relative '../../app'

# Provide method to convert SVG files to PDF.
#
# @see Aldine::Cli::Commands::Shared::SvgConv
module Aldine::Cli::Commands::Concerns::SvgConvert
  protected

  # Convert given file (to PDF).
  #
  # @param [Pathname] filepath
  #
  # @return [Pathname] as output file
  def svg_convert(filepath)
    svg_converter.call(filepath)
  end

  # Get an instance of ``SvgConv`` ready to process files.
  #
  # @api private
  #
  # @return [Aldine::Cli::Commands::Shared::SvgConv]
  def svg_converter
    Aldine::Cli::Commands::Shared::SvgConv.new(**svg_converter_options)
  end

  # @return [Hash{Symbol => Object}]
  def svg_converter_options
    {
      cache: self.respond_to?(:cache?, true) ? self.__send__(:cache?) : true,
      debug: self.respond_to?(:debug?, true) ? self.__send__(:debug?) : false,
      tmpdir: self.respond_to?(:tmpdir, true) ? self.__send__(:tmpdir) : nil,
    }
  end
end
