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

# tasks ----------------------------------------------------------------------

task default: [:'tex:build']

unless Rake::Task.task_defined?(:setup)
  desc 'Setup'
  task :setup do
    fs = FileUtils::Verbose

    Pathname.new('ruby').tap do |directory|
      unless directory.directory?
        Bundler.locked_gems.specs.keep_if { |v| v.name == 'rqb' }.fetch(0).full_gem_path.tap do |fp|
          fs.rm_f(directory)
          fs.ln_sf(fp, directory)
        end
      end
    end
  end
end

desc 'Docker build'
task :'docker:build' do
  Rqb::Local::Docker.build
end

desc 'Shell'
task shell: %w[docker:build setup] do
  Rqb::Local::Docker.run
end

desc 'Irb'
task irb: %w[docker:build setup] do
  Rqb::Local::Docker.rake(:shell, path: 'src')
end

desc 'TeX sync'
task 'tex:sync': %w[docker:build setup] do
  Rqb::Local::Docker.rake(:sync, path: 'src')
end

desc 'TeX build'
task 'tex:build': %w[tex:sync] do
  Rqb::Local::Docker.rake(:all, path: 'tmp')
end

desc 'TeX log'
task 'tex:log': %w[docker:build setup] do
  Rqb::Local::Docker.rake(:log, path: 'src')
end
