# frozen_string_literal: true

require_relative '../erb_command'

# Responsible of highlighting code.
class Aldine::Cli::Base::ErbCommand::Rouge
  autoload(:Rouge, 'rouge')

  # @param [IO, Object, nil] output
  def initialize(output: $stdout)
    self.tap do
      self.output = output
    end.freeze
  end

  # @param [String] source
  def call(source)
    formatter.format(lexer.lex(source)).tap do |content|
      output&.write(content)
    end
  end

  protected

  # @return [IO, Object, nil]
  attr_accessor :output

  # @return [Rouge::Formatters::Formatter]
  def formatter
    Rouge::Formatters::Terminal256.new
  end

  # @return [Rouge::Lexers::TeX]
  def lexer
    Rouge::Lexers::TeX.new
  end
end
