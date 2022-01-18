# frozen_string_literal: true

require_relative '../remote'

autoload(:Pathname, 'pathname')

# Synchronize directories based on rsync
class Rqb::Remote::Synchro < Rqb::Shell::Command
  def initialize(origin, target, env: {})
    [
      "#{Pathname.new(origin).expand_path}/",
      Pathname.new(target).expand_path.to_s
    ].tap do |paths|
      self.class.command.concat(paths).tap { |command| super(command, env: env) }
    end
  end

  class << self
    def command
      %w[rsync -raHq --delete]
    end
  end
end
