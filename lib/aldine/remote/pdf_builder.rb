# frozen_string_literal: true

require_relative '../remote'

# PDF builder
#
# Filenames for TEX files: [LATEX_NAME].[TYPE].tex
class Aldine::Remote::PdfBuilder
  autoload(:Pathname, 'pathname')

  # @param [Symbol] type
  # @param [Hash, Config] config
  # @param [Hash{String => String]}]
  def initialize(type, config: nil, env: {})
    @config = config || ::Aldine::Remote::Config.new
    @env = env || {}
    @type = type.to_sym
  end

  # @return [Pathname]
  def call
    output.tap { sequence.map(&:call) }
  end

  # @return [String]
  def jobname
    [config.fetch(:output_name), type].join('.')
  end

  # @return [String]
  def filename
    [config.fetch(:latex_name), type, 'tex'].join('.')
  end

  # @return [Pahname]
  def output
    Pathname.new("#{jobname}.pdf").expand_path
  end

  # noinspection RubyLiteralArrayInspection
  class << self
    def options
      ['-halt-on-error', '-interaction=batchmode', '-shell-escape']
    end
  end

  protected

  # @return [Hash{String => String}]
  attr_reader :env

  # @return [Hash]
  attr_reader :config

  # @return [Symbol]
  attr_reader :type

  # @return [Array<Shell::Coomand>]
  def sequence
    ['pdflatex'].concat(self.class.options).concat(["-jobname=#{jobname}", filename]).yield_self do |cmd|
      [
        ::Aldine::Shell::Command.new(cmd, env: env),
        ::Aldine::Shell::Command.new(['makeindex', filename], env: env),
        ::Aldine::Shell::Command.new(cmd, env: env),
      ]
    end
  end
end
