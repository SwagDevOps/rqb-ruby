# frozen_string_literal: true

require_relative '../local'

# Local to docker communication methods.
module Local::Docker
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
        '-v', "#{Dir.pwd}/.tmp:/tmp/u#{user.uid}",
        '-v', "#{Dir.pwd}/ruby:/workdir/ruby:ro",
        '-v', "#{Dir.pwd}/vendor/bundle:/workdir/vendor/bundle:ro",
        '-v', "#{Dir.pwd}/.bundle:/workdir/.bundle:ro",
        '-v', "#{Dir.pwd}/src:/workdir/src:ro",
        '-v', "#{Dir.pwd}/out:/workdir/out",
        '-v', "#{Dir.pwd}/tmp:/workdir/tmp",
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
      ::Local::Shell
    end

    def tex
      ::Local::Tex
    end
  end
end
