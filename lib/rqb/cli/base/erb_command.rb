# frozen_string_literal: true

require_relative '../app'

# Base for templated command.
#
# @abstract
class Rqb::Cli::Base::ErbCommand < Rqb::Cli::Base::BaseCommand
  "#{__dir__}/erb_command".tap do |path|
    {
      Output: :output,
      OutputType: :output_type,
      Rouge: :rouge,
      Template: :template,
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end

  class << self
    protected

    # rubocop:disable Metrics/MethodLength

    def inherited(subclass)
      super(subclass) do
        subclass.class_eval do
          parameter('SOURCE', 'source file (or directory)', { attribute_name: :param_source })
          option('--[no-]debug', :flag, 'enable debug messages', { default: true })
          option(%w[-O --output], 'OUTPUT',
                 "output type {#{OutputType.types.join('|')}}",
                 {
                   default: OutputType.default.to_s,
                   attribute_name: :param_output
                 })
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end

  # @!method debug?
  #   Denotes debug is active
  #   @return [Boolean]

  # @!attribute [rw] param_output
  #   @return [String]

  # Get variables.
  #
  # @abstract
  #
  # @return [Hash{Symbol => Object}]
  def variables
    {}
  end

  # Get file (or directory) given to be processed.
  #
  # @return [Pathname]
  def source
    # noinspection RubyResolve
    @param_source.then do |fp|
      raise '@param_source must be set' if [nil, ''].include?(fp)

      Pathname.new(fp).expand_path
    end
  end

  def execute
    output_type = OutputType.new(param_output)

    render.tap do |content|
      unless output_type.disabled?
        rouge.call(content) if output_type.term?
        output.call(content) if output_type.file?
      end
    end
  end

  # Render template.
  #
  # @return [String]
  def render
    template.call(variables)
  end

  protected

  def rouge
    Rouge.new
  end

  # Instance responsible to output a file result.
  #
  # @return [Output]
  def output
    Output.new(output_basepath, template_name, verbose: debug?)
  end

  # Path used to output file (almost a filepath).
  #
  # @abstract
  #
  # @return [String]
  def output_basepath
    raise NotImplementedError
  end

  # Instance responsible to template generated variables.
  #
  # @return [Template]
  def template
    Template.new(template_name, debug: debug?)
  end

  # Get the name (without extension) for the template.
  #
  # @return [String]
  def template_name
    self.class.name.split('::').last.gsub(/(.)([A-Z])/, '\1_\2').downcase.gsub(/_command$/, '')
  end
end
