# frozen_string_literal: true

require_relative '../rqb'
autoload(:Clamp, 'clamp')

# Namespace module
module Rqb::Cli
  "#{__dir__}/cli".tap do |path|
    {
      App: :app,
      Erb: :erb,
      LegacyApp: :legacy_app, # @todo remove legacy app
      ErbChapters: :erb_chapters,
      ErbHyperrefSetup: :erb_hyperref_setup,
      ErbImageFull: :erb_image_full,
      Svg2Pdf: :svg2pdf,
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end

  # Namespace for commands
  module Commands
  end

  # Namespace for base (abstract) commands
  module Base
    "#{__dir__}/cli/base".tap do |path|
      {
        ErbCommand: :erb_command,
      }.each { |k, v| autoload(k, "#{path}/#{v}") }
    end
  end

  # Base class for subcommands.
  #
  # @abstract
  class Command < ::Clamp::Command
  end
end
