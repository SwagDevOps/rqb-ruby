# frozen_string_literal: true

require_relative '../aldine'

# Shell utilities
module Aldine::Shell
  {
    Chalk: :chalk,
    Command: :command,
    CommandError: :command_error,
    Readline: :readline,
  }.each { |k, v| autoload(k, "#{__dir__}/shell/#{v}") }
end
