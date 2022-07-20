# frozen_string_literal: true

require_relative '../erb_command'

# Template on top of ERB.
class Rqb::Cli::Base::ErbCommand::Template
  autoload(:ERB, 'erb')
  autoload(:Pathname, 'pathname')

  # @return [String]
  attr_reader :name

  # @param [String] name
  def initialize(name)
    self.name = name.freeze
  end

  # Render template.
  #
  # @return [String]
  def call(variables)
    bind(variables).then { |b| erb.result(b) }
  end

  protected

  attr_writer :name

  def erb
    # @see https://github.com/rubocop/rubocop/pull/5845#issuecomment-1008348049
    ERB.new(self.read.to_s, trim_mode: '>')
  end

  # Read template file.
  #
  # @@return [String, nil]
  def read
    file&.read
  end

  # Make binding for ERB rendering and variables lookup.
  #
  # @param [Hash{Symbol => Object}] variables
  #
  # @return [Binding]
  def bind(variables)
    { env: ENV.to_h.freeze }
      .merge(variables)
      .then { |vars| Struct.new(*vars.keys).new(*vars.values) }
      .then { |container| container.freeze.instance_eval { binding } }
  end

  # Get template file path.
  #
  # @return [Pathname, nil]
  def file
    paths
      .map { |path| path.join("#{name}.tex.erb") }
      .keep_if { |fp| fp.file? and fp.readable? }
      .first
  end

  # Paths to stored template files.
  #
  # @return [Array<Pathname>]
  def paths
    [
      Pathname.new(__dir__).join('../..', 'erb').realpath
    ]
  end
end
