# frozen_string_literal: true

require_relative '../app'

# Base for templated command.
#
# @abstract
class Rqb::Cli::Base::ErbCommand < Rqb::Cli::Command
  autoload(:ERB, 'erb')
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')

  # Get variables.
  #
  # @abstract
  #
  # @return [Hash{Symbol => Object}]
  def variables
    {}
  end

  def execute
    # @todo actual rendering
    puts render
  end

  # Render template.
  #
  # @return [String]
  def render
    template.result(template_binding)
  end

  protected

  # Get binding for ERB rendering and variables lookup.
  #
  # @return [Binding]
  def template_binding
    { env: ENV.to_h.freeze }
      .merge(variables)
      .then { |variables| Struct.new(*variables.keys).new(*variables.values) }
      .then { |container| container.freeze.instance_eval { binding } }
  end

  def template
    # @see https://github.com/rubocop/rubocop/pull/5845#issuecomment-1008348049
    ERB.new(template_content.to_s, trim_mode: '>')
  end

  # @@return [String, nil]
  def template_content
    template_file&.read
  end

  # Get template file path.
  #
  # @return [Pathname, nil]
  def template_file
    template_paths
      .map { |path| path.join("#{template_name}.tex.erb") }
      .keep_if { |fp| fp.file? and fp.readable? }
      .first
  end

  # Get the name (without extension) for the template.
  #
  # @return [String]
  def template_name
    self.class.name.split('::').last.gsub(/(.)([A-Z])/, '\1_\2').downcase.gsub(/_command$/, '')
  end

  # Paths to stored template files.
  #
  # @return [Array<Pathname>]
  def template_paths
    [
      Pathname.new(__dir__).join('..', 'erb').realpath
    ]
  end
end
