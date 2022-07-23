# frozen_string_literal: true

require_relative '../app'

# Base command.
#
# @abstract
class Rqb::Cli::Base::BaseCommand < Rqb::Cli::Command
  class << self
    protected

    def inherited(subclass, &block)
      super(subclass).then { block&.call(subclass) }
    end
  end
end
