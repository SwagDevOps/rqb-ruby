# frozen_string_literal: true

require_relative '../app'

# Base for templated command.
#
# @abstract
class Rqb::Cli::Base::ErbCommand < Rqb::Cli::Command
  "#{__dir__}/erb_command".tap do |path|
    {
      Output: :output,
      Template: :template,
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end

  class << self
    def inherited(subclass)
      super.tap do
        subclass.class_eval do
          parameter 'SRC', 'source file', attribute_name: :param_file
          option(['--[no-]debug'], :flag, 'enable debug messages', default: true)
        end
      end
    end
  end

  # @!method debug?
  #   Denotes debug is active
  #   @return [Boolean]

  # Get variables.
  #
  # @abstract
  #
  # @return [Hash{Symbol => Object}]
  def variables
    {}
  end

  # Get file given to be processed.
  #
  # @return [Pathname]
  def input_file
    # noinspection RubyResolve
    @param_file.then do |fp|
      raise '@param_file must be set' if [nil, ''].include?(fp)

      Pathname.new(fp).expand_path
    end
  end

  def execute
    # @todo provide switch to render without writing files
    render.tap do |content|
      output.call(content)
    end
  end

  # Render template.
  #
  # @return [String]
  def render
    template.call(variables)
  end

  protected

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
