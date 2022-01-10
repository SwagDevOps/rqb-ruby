# frozen_string_literal: true

require_relative '../rqb'

# @abstract
class Rqb::ErbApp < Rqb::CliApp
  autoload(:ERB, 'erb')
  autoload(:Pathname, 'pathname')
  autoload(:FileUtils, 'fileutils')

  # @return [Array<String>]
  attr_reader :arguments

  # @return [Hash{Symbol => Object}]
  attr_reader :options

  def initialize(*)
    -> { super }.tap do
      @fs = FileUtils::Verbose
    end.call
  end

  class << self
    # Behave as ``__FILE__`` during class inheritance.
    #
    # @return [Pathname]
    def path
      @path = Pathname.new(@path || caller_locations.first.path).freeze
    end

    protected

    attr_writer :path

    alias file= path=
  end

  # Get variables.
  #
  # @return [Hash{Symbol => Object}]
  def variables
    {}
  end

  # @return [String]
  def output_basepath
    raise NotImplementedError
  end

  # File written during call.
  #
  # @return [Pathname]
  def output_file
    [output_basepath, class_file.basename.to_s, 'tex'].join('.').then { |fp| Pathname.new(fp) }
  end

  # Write file.
  #
  # @return [String]
  def call
    render.tap do |s|
      fs.mkdir_p(output_file.dirname)
      fs.touch(output_file)

      output_file.write(s)
    end
  end

  # Get template file path.
  #
  # @return [Pathname]
  def template
    [
      Pathname.new(class_file).dirname.to_s,
      '..',
      "#{Pathname.new(class_file).basename('.rb').to_s.gsub('-', '/').dup}.tex.erb"
    ].join('/').then { |fp| Pathname.new(fp).realpath }
  end

  # Render template.
  #
  # @return [String]
  def render
    { env: ENV.to_h }.merge(variables).then do |vars|
      Struct.new(*vars.keys).new(*vars.values).yield_self do |renderer|
        # @see https://github.com/rubocop/rubocop/pull/5845#issuecomment-1008348049
        # rubocop:disable Lint/ErbNewArguments
        ERB.new(template.read, 0, trim_mode: '>').result(renderer.instance_eval { binding })
        # rubocop:enable Lint/ErbNewArguments
      end
    end
  end

  protected

  # @return [Class<FileUtils::Verbose>]
  attr_accessor :fs

  # @return [Pathname]
  def class_path
    self.class.path
  end

  alias class_file class_path
end
