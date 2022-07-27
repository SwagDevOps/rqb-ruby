# frozen_string_literal: true

require_relative '../app'

# Process chapters/sections.
#
# Sample of use:
#
# ```
# aldine chapters .
# aldine chapters chapters
# aldine chapters chapters.yml
# ````
class Rqb::Cli::Commands::ChaptersCommand < Rqb::Cli::Base::ErbCommand
  autoload(:YAML, 'yaml')

  def output_basepath
    input_file.expand_path.dirname.join(input_file.basename('.*')).to_path
  end

  def variables
    {
      files: files,
      chapters: files.map { |str| str.to_s.gsub(/\.tex$/, '') },
    }
  end

  # File used to process chapters.
  #
  # Input file SHOULD:
  #
  #  * have the ``.yml`` extension.
  #  * or have no extension
  #  * or be a directory
  #
  # @return [Pathname]
  def input_file
    return source.join("#{template_name}.yml") if source.directory?

    Pathname.new("#{source.to_s.gsub(/\.yml$/, '')}.yml").freeze
  end

  protected

  # Where TeX files are located.
  #
  # @return [Pathname]
  def texfiles_basedir
    input_file.expand_path.dirname.join(options.fetch(:basedir))
  end

  # Load YAML file.
  #
  # @return [Array<String>]
  def yaml_load
    YAML.safe_load(input_file.read)
  end

  # @return [Array<Pathname>]
  def files
    yaml_load.map { |fp| texfiles_basedir.join("#{fp}.tex").freeze }
  end

  # Get some options.
  #
  # This code is legacy amd SHOULD BE removed in the future.
  #
  # @api private
  #
  # @return {Hash{Symbol => Object}}
  def options
    { basedir: input_file.basename('.*').to_s }
  end
end
