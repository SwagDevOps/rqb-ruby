# frozen_string_literal: true

require_relative '../lib'

# Module related to rake local tasks.
module Local
  "#{__dir__}/local".tap do |path|
    {
      Docker: 'docker',
      Shell: 'shell',
      Tex: 'tex',
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end
end
