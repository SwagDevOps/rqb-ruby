# frozen_string_literal: true

require_relative '../rqb'

# Module related to rake local tasks.
module Rqb::Local
  "#{__dir__}/local".tap do |path|
    {
      Config: 'config',
      Docker: 'docker',
      Shell: 'shell',
      Tex: 'tex',
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end
end
