# frozen_string_literal: true

require_relative '../shell'

# @abstract
class Shell::Command
  autoload(:Shellwords, 'shellwords')

  # Mutex used to ensure atomicity on system calls
  #
  # @api private
  SYSTEM_LOCK = Mutex.new

  # @param [Array<String>] arguments
  # @param [Hash{ String => String }] env
  def initialize(arguments, env: {})
    super().tap do
      require 'english'

      @silent = @silent.nil? ? false : @silent
      @arguments = arguments.clone.map(&:freeze).freeze
      @env = env.clone.map { |k, v| [k.freeze, v.freeze] }.to_h.freeze
    end.freeze
  end

  # @return [Boolean]
  def silent?
    !!@silent
  end

  # @return [Array<String>]
  def to_a
    arguments.clone.dup
  end

  # @return [Hash{String => String}]
  def env
    @env.clone.dup
  end

  def to_s
    Shellwords.join(self.to_a)
  end

  alias inspect to_a

  # @return [Process::Status]
  def call
    inner_call do
      SYSTEM_LOCK.synchronize do
        -> { $CHILD_STATUS }.tap do |stat|
          Kernel.system(*system_args).tap do |res|
            raise Shell::CommandError.new(self.to_a, status: stat.call) unless res
          end
        end.call
      end
    end
  end

  protected

  # @return [Array<String>]
  attr_reader :arguments

  def system_args
    [env, *self.to_a]
  end

  def warn(message)
    Kernel.warn(message)
  end

  def inner_call(&block)
    warn(self.to_s) unless silent?
    block.call
  end
end
