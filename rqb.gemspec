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
    "aldine",
    "erb-chapters",
    "erb-hyperref_setup",
    "erb-image_full",
    "svg2pdf",
  ]
  s.files         = [
    ".yardopts",
    "README.md",
    "bin/aldine",
    "bin/erb-chapters",
    "bin/erb-hyperref_setup",
    "bin/erb-image_full",
    "bin/svg2pdf",
    "erb/chapters.tex.erb",
    "erb/hyperref_setup.tex.erb",
    "erb/image_full.tex.erb",
    "lib/rqb.rb",
    "lib/rqb/bundleable.rb",
    "lib/rqb/cli.rb",
    "lib/rqb/cli/app.rb",
    "lib/rqb/cli/app/loader.rb",
    "lib/rqb/cli/app/loader/parser.rb",
    "lib/rqb/cli/base/base_command.rb",
    "lib/rqb/cli/base/erb_command.rb",
    "lib/rqb/cli/base/erb_command/output.rb",
    "lib/rqb/cli/base/erb_command/output_type.rb",
    "lib/rqb/cli/base/erb_command/rouge.rb",
    "lib/rqb/cli/base/erb_command/template.rb",
    "lib/rqb/cli/commands/chapters_command.rb",
    "lib/rqb/cli/commands/concerns/image_match.rb",
    "lib/rqb/cli/commands/concerns/svg_convert.rb",
    "lib/rqb/cli/commands/miniature_command.rb",
    "lib/rqb/cli/commands/sample_command.rb",
    "lib/rqb/cli/commands/shared/files_matcher.rb",
    "lib/rqb/cli/commands/shared/svg_conv.rb",
    "lib/rqb/cli/commands/svg_conv_command.rb",
    "lib/rqb/cli/erb.rb",
    "lib/rqb/cli/erb_chapters.rb",
    "lib/rqb/cli/erb_hyperref_setup.rb",
    "lib/rqb/cli/erb_image_full.rb",
    "lib/rqb/cli/legacy_app.rb",
    "lib/rqb/cli/svg2pdf.rb",
    "lib/rqb/local.rb",
    "lib/rqb/local/config.rb",
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

  s.add_runtime_dependency("clamp", ["~> 1.3"])
  s.add_runtime_dependency("faker", ["~> 2.21"])
  s.add_runtime_dependency("kamaze-version", ["~> 1.0"])
  s.add_runtime_dependency("rouge", ["~> 3.29"])
  s.add_runtime_dependency("stibium-bundled", ["~> 0.0", ">= 0.0.4"])
  s.add_runtime_dependency("yard", ["~> 0.9"])
end

# Local Variables:
# mode: ruby
# End:
