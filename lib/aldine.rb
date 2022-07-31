# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'English'

# Namespace module
module Aldine
  autoload(:Pathname, 'pathname')

  Pathname.new(__dir__).join('aldine').then do |libdir|
    {
      Bundleable: :bundleable,
      Cli: :cli,
      Remote: :remote,
      Shell: :shell,
      Local: :local,
    }.each { |k, v| autoload(k, libdir.join(v.to_s)) }

    include Bundleable

    # @todo use autoload mechanism to set VERSION constant
    lambda do
      require('kamaze/version')

      self.const_set(:VERSION, ::Kamaze::Version.new(libdir.join('version.yml')).freeze)
    end.then do |f|
      f.call unless self.constants(false).include?(:VERSION)
    end
  end
end
