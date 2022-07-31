# frozen_string_literal: true

require_relative '../cli'

# Process chapters.
class Aldine::Cli::ErbChapters < Aldine::Cli::Erb
  autoload(:YAML, 'yaml')

  def output_basepath
    param.expand_path.dirname.join(param.basename('.*'))
  end

  def variables
    {
      files: files,
      chapters: files.map { |str| str.to_s.gsub(/\.tex$/, '') },
    }
  end

  def options
    { basedir: param.basename('.*').to_s }.merge(super)
  end

  def call
    files.map(&:realpath).yield_self { super }
  end

  protected

  def param
    Pathname.new("#{arguments.fetch(0)}.yml")
  end

  # @return [Array<Pathname>]
  def files
    YAML.safe_load(param.read).map do |name|
      param.dirname.join(options.fetch(:basedir), "#{name}.tex").freeze
    end
  end
end
