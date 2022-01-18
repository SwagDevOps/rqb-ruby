# frozen_string_literal: true

# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

# noinspection RubyLiteralArrayInspection
Gem::Specification.new do |s|
  s.name        = "rqb"
  s.version     = "0.0.1"
  s.date        = "2021-01-10"
  s.summary     = "Light utilities for LaTeX"
  s.description = "Light utilities for LaTeX (standalone document preparation system)"

  s.licenses    = ["LGPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/rqb-ruby"

  s.required_ruby_version = ">= 2.7.0"
  s.require_paths = ["lib"]
  s.bindir        = "bin"
  s.executables   = [
    "erb-chapters",
    "erb-hyperref_setup",
    "erb-image_full",
    "svg2pdf",
  ]
  s.files         = [
    ".yardopts",
    "README.md",
    "bin/erb-chapters",
    "bin/erb-hyperref_setup",
    "bin/erb-image_full",
    "bin/svg2pdf",
    "erb/chapters.tex.erb",
    "erb/hyperref_setup.tex.erb",
    "erb/image_full.tex.erb",
    "lib/rqb.rb",
    "lib/rqb/bundleable.rb",
    "lib/rqb/cli_app.rb",
    "lib/rqb/erb_app.rb",
    "lib/rqb/local.rb",
    "lib/rqb/local/docker.rb",
    "lib/rqb/local/shell.rb",
    "lib/rqb/local/tasks.rb",
    "lib/rqb/local/tex.rb",
    "lib/rqb/remote.rb",
    "lib/rqb/remote/config.rb",
    "lib/rqb/remote/inotify_wait.rb",
    "lib/rqb/remote/path.rb",
    "lib/rqb/remote/pdf_builder.rb",
    "lib/rqb/remote/synchro.rb",
    "lib/rqb/remote/tasks.rb",
    "lib/rqb/shell.rb",
    "lib/rqb/shell/chalk.rb",
    "lib/rqb/shell/command.rb",
    "lib/rqb/shell/command_error.rb",
    "lib/rqb/shell/readline.rb",
    "lib/rqb/version.yml",
  ]

  s.add_runtime_dependency("kamaze-version", ["~> 1.0"])
  s.add_runtime_dependency("stibium-bundled", ["~> 0.0", ">= 0.0.4"])
end

# Local Variables:
# mode: ruby
# End:
