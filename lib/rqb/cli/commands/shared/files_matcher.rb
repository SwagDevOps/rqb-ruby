# frozen_string_literal: true

require_relative '../../app'

# Files matcher
#
# Provide methods to match files with a filepath without extension (``source``).
class Rqb::Cli::Commands::Shared::FilesMatcher
  # @param [Array<Symbols>] extensions
  def initialize(extensions)
    super().tap do
      self.extensions = extensions.map(&:to_sym).freeze
    end.freeze
  end

  # Get matches based on source.
  #
  # Matches are indexed by file extension, and sorted by extensions precedence.
  #
  # @param [Pathname] source
  #
  # @return [Hash{Symbol => Pathname}]
  def call(source)
    source.expand_path.dirname.glob("#{source.basename}.*").then do |matches|
      matches
        .map { |match| [match.extname.to_s.downcase.gsub(/^\./, '').to_sym, match] }
        .keep_if { |ext, _| searched_extensions.include?(ext) }
        .sort_by { |ext, _| searched_extensions.find_index(ext) || matches.length }
        .to_h
    end
  end

  protected

  # @return [Array<Symbols>]
  attr_accessor :extensions

  alias searched_extensions extensions
end
