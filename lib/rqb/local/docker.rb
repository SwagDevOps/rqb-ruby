# frozen_string_literal: true

require_relative '../local'

# Local to docker communication methods.
module Rqb::Local::Docker
  class << self
    def user
      shell.user
    end

    def image
      "u#{user.uid}/texlive-#{tex.project_name}"
    end

    def directories
      [
        # tex directories -----------------------------------------------------
        'out',
        'src',
        'tmp',
        # bundler directories -------------------------------------------------
        'vendor/bundle',
        '.bundle',
      ].sort.freeze
    end

    def build
      shell.sh('/usr/bin/env', 'docker', 'build', '-t', image, './docker')
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

    def run(command = [], path: nil)
      fs.mkdir_p(directories)

      shell.sh(*[
        '/usr/bin/env', 'docker', 'run', '--rm',
        shell.tty? ? '-it' : nil,
        '--user', [user.uid, user.gid].join(':'),
        '-e', "TERM=#{ENV.fetch('TERM', 'xterm')}",
        '-e', "OUTPUT_NAME=#{tex.output_name}",
        '-e', "TMPDIR=/tmp/u#{user.uid}",
        '-e', 'PATH=/workdir/ruby/bin:/usr/local/bin:/usr/bin:/bin',
        '-v', "#{shell.pwd.join('.tmp').realpath}:/tmp/u#{user.uid}",
        '-v', "#{shell.pwd.join('ruby').realpath}:/workdir/ruby:ro",
        '-v', "#{shell.pwd.join('vendor/bundle').realpath}:/workdir/vendor/bundle:ro",
        '-v', "#{shell.pwd.join('.bundle').realpath}:/workdir/.bundle:ro",
        '-v', "#{shell.pwd.join('src').realpath}:/workdir/src:ro",
        '-v', "#{shell.pwd.join('out').realpath}:/workdir/out",
        '-v', "#{shell.pwd.join('tmp').realpath}:/workdir/tmp",
        '-w', "/workdir/#{path}",
        image
      ].concat(command))
    end

    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def rake(task, path: nil)
      run([
            'rake', task.to_s,
            'OUT_DIR=out',
            'SRC_DIR=src',
            'TEX_DIR=tmp',
            'LATEX_NAME=index',
          ], path: path)
    end

    protected

    def fs
      shell.fs
    end

    def shell
      ::Rqb::Local::Shell
    end

    def tex
      ::Rqb::Local::Tex
    end
  end
end
