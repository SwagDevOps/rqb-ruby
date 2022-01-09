# frozen_string_literal: true

# Define local tasks runnable through rake.
#
# The default task is to generate TeX output files.
# Tasks strictly relating to LaTeX live in the ``tex`` namespace.

require_relative('../local').then { require 'rake' }

# environment ----------------------------------------------------------------

caller_locations.fetch(0).to_s.then do |fp|
  ENV['TEX_PROJECT_NAME'] ||= Pathname.new(fp).dirname.basename.to_s.freeze
end

# tasks ----------------------------------------------------------------------

task default: [:'tex:build']

desc 'Docker build'
task :'docker:build' do
  Local::Docker.build
end

desc 'Shell'
task shell: :'docker:build' do
  Local::Docker.run
end

desc 'Irb'
task irb: :'docker:build' do
  Local::Docker.rake(:shell, path: 'src')
end

desc 'TeX sync'
task 'tex:sync': :'docker:build' do
  Local::Docker.rake(:sync, path: 'src')
end

desc 'TeX build'
task 'tex:build': :'tex:sync' do
  Local::Docker.rake(:all, path: 'tmp')
end

desc 'TeX log'
task 'tex:log': :'docker:build' do
  Local::Docker.rake(:log, path: 'src')
end
