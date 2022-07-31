# frozen_string_literal: true

require_relative '../remote'

# Wrapper built on top of ``inotifywait``
class Aldine::Remote::InotifyWait < ::Aldine::Shell::Readline
  autoload(:YAML, 'yaml')

  def initialize(*paths, env: {})
    @silent = true
    super(self.class.command.concat(paths), env: env)
  end

  # rubocop:disable Metrics/MethodLength

  def call(&block)
    super do |stream, **kwargs|
      if kwargs[:source].eql?(:stdout)
        stream.each_line do |line|
          YAML.safe_load(line).tap do |h|
            block.call(h.keys.fetch(0), h.values.fetch(0))
          end
        end
      else
        stream.each_line { |line| warn(line) }
      end
    end
  end

  # rubocop:enable Metrics/MethodLength

  class << self
    def command
      [
        'inotifywait',
        '-e', 'CLOSE_WRITE', '-e', 'DELETE', '-e', 'MOVED_TO', '-e', 'CREATE',
        '--format', '{"%w%f": [%e]}', '-rm'
      ]
    end
  end
end
