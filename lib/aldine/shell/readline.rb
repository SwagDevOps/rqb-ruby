# frozen_string_literal: true

require_relative '../shell'

# Readline facilty.
#
# ```ruby
# Shell::Readline.new(['yes']).call do |stream, **kwargs|
#   stream.each_line { |line| puts line } if kwargs[:source]&.eql?(:stdout)
# end
# ```
class Aldine::Shell::Readline < Aldine::Shell::Command
  autoload(:Open3, 'open3')

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

  # @param [nil, false, Proc] interrupt_handler
  #
  # @return [Process::Status]
  #
  # Sample of use:
  #
  # ```ruby
  # Shell::Readline.new(['yes']).call do |stream, **kwargs|
  #   stream.each_line { |line| puts line } if kwargs[:source]&.eql?(:stdout)
  # end
  # ```
  def call(interrupt_handler: nil, &block)
    inner_call do
      Open3.popen3(*system_args) do |stdin, stdout, stderr, thread|
        stdin.close
        thread.tap do
          thread.abort_on_exception = true
          { stdout: stdout, stderr: stderr }.map do |source, stream|
            Thread.new { block.call(stream, source: source) }
          end.map do |thr|
            thr&.abort_on_exception = true
            thr&.join
          rescue Interrupt, SystemExit => e
            (interrupt_handler.nil? ? default_interrupt_handler : interrupt_handler).tap do |handler|
              handler ? handler.call(thr, e) : raise
            end
          end
          thread.join
        end.value
      end
    end
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  protected

  # @return [Proc]
  def default_interrupt_handler
    lambda do |thread, error|
      warn(error.class)

      thread.kill
    end
  end
end
