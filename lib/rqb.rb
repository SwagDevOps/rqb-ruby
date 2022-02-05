# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'English'

# Namespace module
module Rqb
  {
    Bundleable: :bundleable,
    Cli: :cli,
    Remote: :remote,
    Shell: :shell,
    Local: :local,
  }.each { |k, v| autoload(k, "#{__dir__}/rqb/#{v}") }

  include Bundleable

  # @todo use autoload mechanism to set VERSION constant
  lambda do
    require('kamaze/version')

    self.const_set(:VERSION, ::Kamaze::Version.new("#{__dir__}/rqb/version.yml").freeze)
  end.then do |f|
    f.call unless self.constants(false).include?(:VERSION)
  end
end
