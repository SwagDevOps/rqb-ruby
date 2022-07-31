# frozen_string_literal: true

require_relative '../aldine'

# Module related to rake local tasks.
module Aldine::Local
  "#{__dir__}/local".tap do |path|
    {
      Config: 'config',
      Docker: 'docker',
      Shell: 'shell',
      Tex: 'tex',
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end
end
