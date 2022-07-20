# frozen_string_literal: true

require_relative '../app'

# Base for templated command.
#
# @abstract
class Rqb::Cli::Base::ErbCommand < Rqb::Cli::Command
  autoload(:FileUtils, 'fileutils')
  "#{__dir__}/erb_command".tap do |path|
    {
      Template: :template,
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end

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
    template.call(variables)
  end

  protected

  def template
    Template.new(template_name)
  end

  # Get the name (without extension) for the template.
  #
  # @return [String]
  def template_name
    self.class.name.split('::').last.gsub(/(.)([A-Z])/, '\1_\2').downcase.gsub(/_command$/, '')
  end
end
