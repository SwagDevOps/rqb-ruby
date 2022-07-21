# frozen_string_literal: true

# Define local tasks runnable through rake.
#
# The default task is to generate TeX output files.
# Tasks strictly relating to LaTeX live in the ``tex`` namespace.

require_relative('../local').then { require 'rake' }

autoload(:Bundler, 'bundler')
autoload(:FileUtils, 'fileutils')
autoload(:Pathname, 'pathname')

# environment ----------------------------------------------------------------

caller_locations.fetch(0).to_s.then do |fp|
  ENV['TEX_PROJECT_NAME'] ||= Pathname.new(fp).dirname.basename.to_s.freeze
end

# config ---------------------------------------------------------------------

config = Rqb::Local::Config

# tasks ----------------------------------------------------------------------

task default: [:'tex:build']

unless Rake::Task.task_defined?(:setup)
  desc 'Setup'
  task :setup do
    # @todo do something with the bin directory of gem
    Bundler.locked_gems.specs.keep_if { |v| v.name == 'rqb' }.fetch(0).full_gem_path
  end
end

desc 'Docker build'
task :'docker:build' do
  Rqb::Local::Docker.build
  Rqb::Local::Docker.install
end

desc 'Shell'
task shell: %w[docker:build setup] do
  Rqb::Local::Docker.run
end

desc 'Irb'
task irb: %w[docker:build setup] do
  Rqb::Local::Docker.rake(:shell, path: config[:src_dir])
end

desc 'TeX sync'
task 'tex:sync': %w[docker:build setup] do
  Rqb::Local::Docker.rake(:sync, path: config[:src_dir])
end

desc 'TeX build'
task 'tex:build': %w[tex:sync] do
  Rqb::Local::Docker.rake(:all, path: config[:tex_dir])
end

desc 'TeX log'
task 'tex:log': %w[docker:build setup] do
  Rqb::Local::Docker.rake(:log, path: config[:src_dir])
end
