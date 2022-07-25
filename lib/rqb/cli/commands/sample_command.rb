# frozen_string_literal: true

require_relative '../app'

# A sample command
#
# This is a simple sample command.
# Illustrates basic features. Produces random quotes in a HP Lovecraft's style.
class Rqb::Cli::Commands::SampleCommand < Rqb::Cli::Base::ErbCommand
  autoload(:Faker, 'faker')
  autoload(:Digest, 'digest')
  autoload(:Pathname, 'pathname')

  def variables
    {
      lovecraft: lovecraft,
    }
  end

  # @return [Pathname, nil]
  def source
    super
  rescue StandardError
    nil
  end

  class << self
    # @todo add a better mechanism to override already defined pararemters
    def parameters
      super.tap do |parameters|
        if parameters[0].name == 'SOURCE'
          parameters[0] = Clamp::Parameter::Definition.new('[SOURCE]', 'source', { attribute_name: :param_source })
        end
      end
    end
  end

  protected

  def output_basepath
    tmpdir.join("#{Digest::SHA1.hexdigest((source || template_name).to_s)}.#{Process.uid}").to_path
  end

  # @return [Class<Faker::Books::Lovecraft>]
  def lovecraft
    Faker::Books::Lovecraft
  end

  def tmpdir
    require('tmpdir').then { Pathname.new(Dir.tmpdir) }
  end
end
