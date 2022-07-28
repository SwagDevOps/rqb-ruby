# frozen_string_literal: true

require_relative '../../app'

# Provide method to convert SVG files to PDF.
#
# @see Rqb::Cli::Commands::Shared::SvgConv
module Rqb::Cli::Commands::Concerns::SvgConvert
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
  # @return [Rqb::Cli::Commands::Shared::SvgConv]
  def svg_converter
    {
      debug: self.respond_to?(:debug?, true) ? self.__send__(:debug?) : false,
      tmpdir: self.respond_to?(:tmpdir, true) ? self.__send__(:tmpdir) : nil,
    }.then do |kwargs|
      Rqb::Cli::Commands::Shared::SvgConv.new(**kwargs)
    end
  end
end
