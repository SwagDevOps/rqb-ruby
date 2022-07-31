# frozen_string_literal: true

# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

# noinspection RubyLiteralArrayInspection
Gem::Specification.new do |s|
  s.name        = "aldine"
  s.version     = "0.0.1"
  s.date        = "2021-01-10"
  s.summary     = "Light utilities for LaTeX"
  s.description = "Light utilities for LaTeX (standalone document preparation system)"

  s.licenses    = ["LGPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/aldine"

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
    "lib/aldine.rb",
    "lib/aldine/bundleable.rb",
    "lib/aldine/cli.rb",
    "lib/aldine/cli/app.rb",
    "lib/aldine/cli/app/loader.rb",
    "lib/aldine/cli/app/loader/parser.rb",
    "lib/aldine/cli/base/base_command.rb",
    "lib/aldine/cli/base/erb_command.rb",
    "lib/aldine/cli/base/erb_command/output.rb",
    "lib/aldine/cli/base/erb_command/output_type.rb",
    "lib/aldine/cli/base/erb_command/rouge.rb",
    "lib/aldine/cli/base/erb_command/template.rb",
    "lib/aldine/cli/commands/chapters_command.rb",
    "lib/aldine/cli/commands/concerns/image_match.rb",
    "lib/aldine/cli/commands/concerns/svg_convert.rb",
    "lib/aldine/cli/commands/miniature_command.rb",
    "lib/aldine/cli/commands/sample_command.rb",
    "lib/aldine/cli/commands/shared/files_matcher.rb",
    "lib/aldine/cli/commands/shared/svg_conv.rb",
    "lib/aldine/cli/commands/svg_conv_command.rb",
    "lib/aldine/cli/erb.rb",
    "lib/aldine/cli/erb_chapters.rb",
    "lib/aldine/cli/erb_hyperref_setup.rb",
    "lib/aldine/cli/erb_image_full.rb",
    "lib/aldine/cli/legacy_app.rb",
    "lib/aldine/cli/svg2pdf.rb",
    "lib/aldine/local.rb",
    "lib/aldine/local/config.rb",
    "lib/aldine/local/docker.rb",
    "lib/aldine/local/shell.rb",
    "lib/aldine/local/tasks.rb",
    "lib/aldine/local/tex.rb",
    "lib/aldine/remote.rb",
    "lib/aldine/remote/config.rb",
    "lib/aldine/remote/inotify_wait.rb",
    "lib/aldine/remote/path.rb",
    "lib/aldine/remote/pdf_builder.rb",
    "lib/aldine/remote/synchro.rb",
    "lib/aldine/remote/tasks.rb",
    "lib/aldine/shell.rb",
    "lib/aldine/shell/chalk.rb",
    "lib/aldine/shell/command.rb",
    "lib/aldine/shell/command_error.rb",
    "lib/aldine/shell/readline.rb",
    "lib/aldine/version.yml",
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
