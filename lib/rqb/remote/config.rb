# frozen_string_literal: true

require_relative '../remote'

# Provide config based on evironment variables
class Rqb::Remote::Config < ::Hash
  class << self
    # @api private
    def mapping
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

  def initialize(env: nil)
    super

    (@env = env || ENV.to_h.clone.freeze).then do
      self.class.mapping.each do |k, default|
        self[k.to_sym] = env(k, default)
      end
    end
  end

  protected

  # Retrieve value from env.
  #
  # Given key is transformed to uppercase as env variable.
  # If not default is given ``KeyError`` is raised.
  #
  # @param [String, Symbol] key
  # @param [Object, nil] default
  #
  # @return [Object]
  def env(key, default = nil)
    @env.fetch(*[key.to_s.upcase, default].compact)
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
