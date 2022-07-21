# frozen_string_literal: true

require_relative '../rqb'

# Shell utilities
module Rqb::Shell
  {
    Chalk: :chalk,
    Command: :command,
    CommandError: :command_error,
    Readline: :readline,
  }.each { |k, v| autoload(k, "#{__dir__}/shell/#{v}") }
end
