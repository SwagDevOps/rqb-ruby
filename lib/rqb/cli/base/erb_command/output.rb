# frozen_string_literal: true

require_relative '../erb_command'

# Responsible of witing files.
class Rqb::Cli::Base::ErbCommand::Output
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')

  # @param [String] basepath
  # @param [Boolean] verbose
  def initialize(basepath, name, verbose: true)
    self.tap do
      self.basepath = basepath
      self.name = name
      # noinspection RubySimplifyBooleanInspection
      self.verbose = !!verbose
    end.freeze
  end

  def verbose?
    self.verbose
  end

  def call(content)
    fs.mkdir_p(file.dirname)
    fs.touch(file)

    file.write(content)
  end

  protected

  # @type [String]
  attr_accessor :basepath

  # @type [String]
  attr_accessor :name

  # @type [Boolean]
  attr_accessor :verbose

  # File written during call.
  #
  # @return [Pathname]
  def file
    [basepath, "erb-#{name}", 'tex'].join('.').then { |fp| Pathname.new(fp) }
  end

  # @return [Module<FileUtils::Verbose>, Module<FileUtils>]
  def fs
    verbose? ? FileUtils::Verbose : FileUtils
  end
end
