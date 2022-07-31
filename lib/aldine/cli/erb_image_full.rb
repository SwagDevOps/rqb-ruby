# frozen_string_literal: true

require_relative '../cli'

# Erb processor for full page image.
class Aldine::Cli::ErbImageFull < Aldine::Cli::Erb
  def variables
    filepath.to_s.then do |fp|
      {
        filepath: fp,
        image: /\.svg$/.match?(fp) ? fp.gsub(/\.svg$/, '.pdf') : fp,
      }
    end
  end

  def call
    (svg2pdf(image_name) if converted?).then { super }
  end

  # @return [String]
  def image_name
    filepath.to_s.then do |fp|
      Pathname.new(fp).dirname.join(File.basename(fp, '.*')).to_s
    end
  end

  alias output_basepath image_name

  # Denote image SHOULD be converted to PDF.
  #
  # @return [Boolean]
  def converted?
    /\.svg$/.match?(filepath.to_s)
  end

  protected

  # @return [Pathname]
  def filepath
    arguments.fetch(0).then do |arg|
      Pathname.new("#{arg}.svg").then { |fp| return fp.realpath.freeze if fp.file? }

      Dir.glob("#{arg}.*").then { |files| Pathname.new(files.fetch(0)).realpath.freeze }
    end
  end

  def svg2pdf(filename)
    Aldine::Cli::Svg2Pdf.new([filename]).call
  end
end
