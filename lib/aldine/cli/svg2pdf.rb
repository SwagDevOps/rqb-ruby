# frozen_string_literal: true

require_relative '../cli'

# Wrapper build on top fo convert
#
# Output is cached and compared by original file md5sum.
class Aldine::Cli::Svg2Pdf < Aldine::Cli::LegacyApp
  autoload(:Digest, 'digest')
  autoload(:Pathname, 'pathname')
  autoload(:FileUtils, 'fileutils')
  autoload(:Base64, 'base64')
  autoload(:JSON, 'json')
  autoload(:Shellwords, 'shellwords')

  def initialize(*)
    -> { super }.tap { @fs = FileUtils::Verbose }.call
  end

  def options
    lambda do
      require 'tmpdir'
      Dir.tmpdir
    end.call.yield_self do |tmpdir|
      { tmpdir: ENV.fetch('TMPDIR', tmpdir) }.compact.merge(super)
    end
  end

  # @return [Pathname]
  def tmpdir
    options.fetch(:tmpdir).yield_self { |fp| Pathname.new(fp) }
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

  # @return [Struct]
  def target
    lambda do
      return Pathname.new(arguments.fetch(0)).realpath if Pathname.new(arguments.fetch(0)).file?

      Pathname.new("#{arguments.fetch(0)}.svg").realpath
    end.call.yield_self do |origin|
      {
        origin: origin,
        output: origin.dirname.join("#{origin.basename('.*')}.pdf"),
        cache_file: self.cache_file_for(origin)
      }.yield_self do |payload|
        Struct.new(:origin, :output, :cache_file, keyword_init: true).new(**payload).tap do |instance|
          instance.singleton_class.tap do |klass|
            klass.define_method(:to_s) { origin.dirname.join(origin.basename('.*').to_s) }
            klass.define_method(:checksum) do
              warn(Shellwords.join(['md5sum', origin.to_s]))

              Digest::MD5.hexdigest(origin.read)
            end
            klass.define_method(:cached?) { !cache.nil? and cache.checksum == checksum }
            klass.define_method(:cache) do
              return nil unless cache_file.file?

              warn(Shellwords.join(['json', '-d', cache_file.to_s])) # inspired by base64 command
              Struct.new(:path, :target, :checksum, :data, keyword_init: true).yield_self do |struct|
                JSON.parse(cache_file.read).transform_keys(&:to_sym).yield_self do |h|
                  struct.new(**h.merge({ data: [h.fetch(:data)].flatten.join }))
                end
              end
            end
          end
        end
      end
    end
  end

  # @return [Pathname] as output file
  def call
    if target.cached?
      target.output.tap do |output_file|
        output_file.write(Base64.decode64(target.cache.data))

        return output_file
      end
    end

    convert.tap do |output_file|
      {
        path: target.cache_file.to_s,
        target: target.to_s,
        checksum: target.checksum,
        data: Base64.encode64(output_file.read).lines.map(&:strip),
      }.tap do |payload|
        fs.mkdir_p(tmpdir)
        fs.touch(target.cache_file)
        target.cache_file.write(JSON.pretty_generate(payload))
      end
    end
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  protected

  # @return [Module<FileUtils>]
  attr_reader :fs

  def convert_command_builder
    lambda do |input_file, output_file|
      # ['rsvg-convert', '-f', 'pdf', '-o', output_file.to_s, input_file.to_s]
      ['cairosvg', '-d', '300', '-u', input_file.to_s, '-o', output_file.to_s]
    end
  end

  # @return [Pathname]
  def convert
    target.output.tap do |output_file|
      convert_command_builder.call(target.origin, output_file).tap do |command|
        warn(Shellwords.join(command))

        unless system(*command)
          raise 'Can not convert %s' % target.origin.to_s.inspect
        end
      end
    end
  end

  # @param [String, Pathname] filepath
  #
  # @return [Pathname]
  def cache_file_for(filepath)
    # noinspection RubyMismatchedReturnType
    [
      Pathname.new(__FILE__).basename('.*').to_s,
      Digest::SHA1.hexdigest(filepath.to_s),
      'json'
    ].then { |parts| tmpdir.join(parts.join('.')) }
  end
end
