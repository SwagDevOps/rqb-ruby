# frozen_string_literal: true

"#{__dir__}/lib".tap do |path|
  $LOAD_PATH.unshift(path)

  {
    Bundleable: :bundleable,
    CliApp: :cli_app,
    ErbApp: :erb_app,
    Shell: :shell,
    Local: :local,
  }.each { |k, v| autoload(k, "#{path}/#{v}") }
end

::Kernel.tap do |receiver|
  receiver.__send__(:include, ::Bundleable)
  receiver.instance_eval do
    lambda do
      require('kamaze/version')

      self.const_set(:VERSION, ::Kamaze::Version.new.freeze)
    end.then do |f|
      f.call unless self.constants(false).include?(:VERSION)
    end
  end
end
