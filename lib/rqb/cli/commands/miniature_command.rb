# frozen_string_literal: true

require_relative '../app'

# Produce miniature markup.
#
# @see http://tug.ctan.org/tex-archive/macros/latex/contrib/floatflt/floatflt.pdf
class Rqb::Cli::Commands::MiniatureCommand < Rqb::Cli::Base::ErbCommand
  include ::Rqb::Cli::Commands::Concerns::ImageMatch
  include ::Rqb::Cli::Commands::Concerns::SvgConvert

  class << self
    protected

    # @return [Hash{Symbol => Object}]
    def defaults
      {
        width: 2.0,
        margin: 0.1,
      }
    end
  end

  # @!attribute [rw] param_width
  #   @return [Float]

  # @!attribute [rw] param_margin
  #   @return [Float]

  {
    width: 'image width',
    margin: 'image margin'
  }.each do |k, desc|
    { default: self.defaults[k], attribute_name: "param_#{k}" }.then do |opts|
      option("--#{k}", k.to_s.upcase, desc, opts) { |s| Float(s) }
    end
  end

  def output_basepath
    source.expand_path.to_path
  end

  # Translates source (filepath without extension) to the best matching file.
  #
  # @return [Pathname]
  def input_file
    image_match!(source)
  end

  # Get image margin (as set from options, or default).
  #
  # @return [Float]
  def margin
    # noinspection RubyMismatchedReturnType
    self.param_margin || defaults[:margin]
  end

  # Get image width (as set from options, or default).
  #
  # @return [Float]
  def width
    # noinspection RubyMismatchedReturnType
    self.param_width || defaults[:width]
  end

  protected

  # @return [Hash{Symbol => Object}]
  def defaults
    self.class.__send__(:defaults)
  end

  # Get dimensions, used in template.
  #
  # @return [Array<Float>]
  def dimensions
    [width + margin, width].freeze
  end

  def variables_builder
    lambda do
      {
        input_file: self.input_file,
        image_file: input_file.extname == '.svg' ? svg_convert(input_file) : input_file,
        dimensions: self.dimensions
      }
    end
  end
end
