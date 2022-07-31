# frozen_string_literal: true

require_relative '../aldine'

# Module related to rake remote tasks.
module Aldine::Remote
  # noinspection RubyLiteralArrayInspection,RubyResolve
  "#{__dir__}/remote".tap do |path|
    {
      Config: :config,
      Path: :path,
      Synchro: :synchro,
      InotifyWait: :inotify_wait,
      PdfBuilder: :pdf_builder,
    }.each { |k, v| autoload(k, "#{path}/#{v}") }
  end
end
