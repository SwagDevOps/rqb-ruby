# frozen_string_literal: true

require_relative '../cli'

# Process hyperref setup.
class Aldine::Cli::ErbHyperrefSetup < Aldine::Cli::Erb
  autoload(:Digest, 'digest')
  autoload(:YAML, 'yaml')

  def output_basepath
    # noinspection RubyYardReturnMatch,RubyMismatchedReturnType
    arguments.fetch(0).to_s
  end

  def defaults
    {
      # options ---------------------------------------------------------------
      config_path: ENV.fetch('WORKDIR').yield_self { |fp| Pathname.new(fp) }.join('src/config'),
      config_file: 'hyperref.yml',
      # arguments -------------------------------------------------------------
      output_basepath: Pathname.new('/tmp').realpath.join(Digest::MD5.hexdigest(__FILE__)),
    }
  end

  # Read config file.
  #
  # @return [Hash{Symbol => String}]
  def config
    YAML.safe_load(config_file.read).map { |k, v| [k.to_sym, v.to_s] }.sort.to_h
  end

  def variables
    {
      config: config
    }
  end

  def arguments
    super.dup.tap do |argumnets|
      argumnets[0] ||= defaults.fetch(:output_basepath)
    end.freeze
  end

  def options
    super.dup.tap do |options|
      options[:config_path] ||= defaults.fetch(:config_path)
      options[:config_file] ||= defaults.fetch(:config_file)
    end.freeze
  end

  protected

  # @return [Pathname]
  def config_file
    Pathname.new(options.fetch(:config_path)).join(options.fetch(:config_file)).freeze
  end
end
