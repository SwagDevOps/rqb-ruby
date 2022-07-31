# frozen_string_literal: true

require_relative '../remote'

# Provide config based on evironment variables
class Aldine::Remote::Config < ::Hash
  class << self
    protected

    # Defaults from env variables (uppercase in environment).
    #
    # @see Config#env()
    #
    # @api private
    def defaults
      {
        tex_dir: 'tmp',
        src_dir: 'src',
        out_dir: 'out',
        output_name: 'book',
        latex_name: 'index',
        watch_exclude: '^.*/(\..+|(M|m)akefile|.*(\.mk|~))$',
      }
    end
  end

  # Store a copy of environment as seen on initialization.
  #
  # @return [Hash]
  attr_reader :env

  def initialize(env: nil)
    super().then { setup(env) }
  end

  protected

  # @param [Hash, ENV, nil] env
  def setup(env)
    @env = env || ENV.to_h.clone.freeze

    self.class.__send__(:defaults).each do |k, default|
      self[k.to_sym] = configure(k, default)
    end
  end

  # Retrieve value from env.
  #
  # Given key is transformed to uppercase as env variable.
  # If not default is given ``KeyError`` is raised when ENV var is not set.
  #
  # @param [String, Symbol] key
  # @param [Object, nil] default
  #
  # @return [Object]
  def configure(key, default = nil)
    # noinspection RubyMismatchedReturnType
    env.fetch(*[key.to_s.upcase, default].compact)
  end

  class << self
    # @param [Symbol|String] key
    #
    # @return [String]
    def [](key)
      # noinspection RubyYardReturnMatch,RubyMismatchedReturnType
      self.new.fetch(key.to_sym)
    end

    alias fetch []
  end
end
