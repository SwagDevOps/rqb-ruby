# frozen_string_literal: true

require_relative '../remote'

autoload(:Pathname, 'pathname')

# Absolute path
class Rqb::Remote::Path < Pathname
  def initialize(path, env: ENV)
    super(Pathname.new(env.fetch('WORKDIR')).join(path))
  end

  class << self
    def configure(key)
      ::Rqb::Remote::Config.new.fetch(key).yield_self { |v| self.new(v) }
    end
  end
end
