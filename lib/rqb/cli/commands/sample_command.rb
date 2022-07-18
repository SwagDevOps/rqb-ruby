# frozen_string_literal: true

require_relative '../app'

# A sample command
class Rqb::Cli::Commands::SampleCommand < Rqb::Cli::Command
  def execute
    puts 'This a sample command'
  end
end
