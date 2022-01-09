# frozen_string_literal: true

# Represent a CLI app
#
# able to basically parse given arguments (<code>ARGV</code>),
# as arguments and options with YAML syntax support.
#
# @abstract
class CliApp
  autoload(:YAML, 'yaml')

  # @return [Array<Object>]
  attr_reader :arguments

  # @return [Hash{Symbol => Object}]
  attr_reader :options

  # @param [Array<String>] argv
  def initialize(argv = ARGV)
    -> { freeze }.tap do
      (@argv = argv.dup.map(&:freeze).freeze).tap do
        self.class.__send__(:parse_argv, argv.dup).tap do |struct|
          @arguments = struct.arguments
          @options = struct.options
        end
      end
    end.call
  end

  class << self
    # rubocop:disable Metrics/AbcSize

    # Parse arguments.
    #
    # options with format ``[a-z]+[a-z -_]+=``
    #
    # @param [Array<String>] argv
    #
    # @return [Struct]
    def parse_argv(argv, yaml: nil)
      yaml ||= ->(str) { YAML.safe_load(str, [Symbol]).freeze }

      /^([a-z]+[a-z -_]+)=(.+)$/.yield_self do |reg|
        # @formatter:off
        {
          arguments: argv.dup.reject { |s| reg.match?(s) }.map { |v| yaml.call(v) }.freeze,
          options: (argv.dup.keep_if { |s| reg.match?(s) })
            .map { |s| [reg.match(s).to_a.fetch(1).gsub(/([-_])+/, '_').to_sym, reg.match(s).to_a.fetch(2)] }
            .to_h
            .transform_values { |v| yaml.call(v) }.freeze
        }.yield_self { |h| Struct.new(*h.keys).new(*h.values).freeze }
        # @formatter:on
      end
    end

    # rubocop:enable Metrics/AbcSize
  end

  protected

  # @return [Array<String>]
  attr_reader :argv
end
