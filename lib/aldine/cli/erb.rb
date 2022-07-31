# frozen_string_literal: true

require_relative '../cli'

# @abstract
class Aldine::Cli::Erb < Aldine::Cli::LegacyApp
  autoload(:ERB, 'erb')
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')

  # @return [Array<String>]
  attr_reader :arguments

  # @return [Hash{Symbol => Object}]
  attr_reader :options

  def initialize(argv = ARGV, template_dir: nil)
    -> { super(argv) }.tap do
      @fs = FileUtils::Verbose
      self.template_dir = template_dir
    end.call
  end

  class << self
    # Default path to stored template files.
    #
    # @return [Pathname]
    def template_dir
      Pathname.new(__dir__).join('../../..').join('erb').realpath
    end
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
    [output_basepath, "erb-#{template_name}", 'tex'].join('.').then { |fp| Pathname.new(fp) }
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
      template_dir,
      "#{template_name}.tex.erb"
    ].join('/').then { |fp| Pathname.new(fp).realpath }
  end

  # Render template.
  #
  # @return [String]
  def render
    { env: ENV.to_h }.merge(variables).then do |vars|
      Struct.new(*vars.keys).new(*vars.values).yield_self do |renderer|
        # @see https://github.com/rubocop/rubocop/pull/5845#issuecomment-1008348049
        ERB.new(template.read, trim_mode: '>').result(renderer.instance_eval { binding })
      end
    end
  end

  protected

  # @return [Class<FileUtils::Verbose>]
  attr_reader :fs

  # @return [Pathname]
  attr_reader :template_dir

  # @return [String]
  def template_name
    self.class.name.split('::').last.gsub(/(.)([A-Z])/, '\1_\2').downcase.gsub(/^erb_/, '')
  end

  def template_dir=(template_dir)
    @template_dir = template_dir ? Pathname.new(template_dir) : self.class.__send__(:template_dir)
  end
end
