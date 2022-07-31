# frozen_string_literal: true

require_relative '../shell'

# Describe a shell error (comand execution without success return code).
class Aldine::Shell::CommandError < ::RuntimeError
  autoload(:Shellwords, 'shellwords')

  # @param [Array<String>] command
  # @param [Process::Status] status
  def initialize(command, status: nil)
    super().tap do
      @command = command.to_a.clone.map(&:freeze).freeze
      @message = Shellwords.join(command).freeze
      @status = status.freeze
    end
  end

  # @return [String]
  attr_reader :message

  alias to_s message

  # @return [Process::Status]
  attr_reader :status

  # @return [Array<String>]
  attr_reader :command
end
