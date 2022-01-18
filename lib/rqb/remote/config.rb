# frozen_string_literal: true

require_relative '../remote'

# Provide config based on evironment variables
class Rqb::Remote::Config < ::Hash
  class << self
    # @api private
    def mapping
      {
        TEX_DIR: :tex_dir,
        SRC_DIR: :src_dir,
        OUT_DIR: :out_dir,
        OUTPUT_NAME: :output_name,
        LATEX_NAME: :latex_name,
        WATCH_EXCLUDE: {
          watch_exclude: '^.*/(\..+|(M|m)akefile|.*(\.mk|~))$'
        }
      }
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

  def initialize
    super

    self.class.mapping.each do |k, v|
      key = (v.is_a?(Hash) ? v.keys.fetch(0) : v).to_sym
      lambda do
        return nil unless v.is_a?(Hash)

        v.values.fetch(0).tap do |blk|
          return ->(*) { blk } unless blk.is_a?(Proc)
        end
      end.call.tap do |blk|
        self[key] = (blk ? ENV.fetch(k.to_s, &blk) : ENV.fetch(k.to_s)).to_s
      end
    end
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  class << self
    # @param [Symbol|String] key
    #
    # @return [String]
    def [](key)
      # noinspection RubyYardReturnMatch
      self.new.fetch(key.to_sym)
    end

    alias fetch []
  end
end
