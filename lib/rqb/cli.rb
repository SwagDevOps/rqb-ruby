# frozen_string_literal: true

require_relative '../rqb'

# Namespace module
module Rqb::Cli
  "#{__dir__}/cli".tap do |path|
    {
      App: :app,
      Erb: :erb,
      ErbChapters: :erb_chapters,
      ErbHyperrefSetup: :erb_hyperref_setup,
      ErbImageFull: :erb_image_full,
      Svg2Pdf: :svg2pdf,
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end
end
