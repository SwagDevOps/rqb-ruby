# frozen_string_literal: true

require_relative '../app'

# A sample command
#
# This is a simple sample command.
# Illustrates basic features. Produces random quotes in a HP Lovecraft's style.
class Rqb::Cli::Commands::SampleCommand < Rqb::Cli::Base::ErbCommand
  autoload(:Faker, 'faker')
  autoload(:Digest, 'digest')

  def variables
    {
      lovecraft: lovecraft,
    }
  end

  protected

  def output_basepath
    "/tmp/#{Digest::SHA1.hexdigest(input_file.to_s)}.#{Process.uid}"
  end

  # @return [Class<Faker::Books::Lovecraft>]
  def lovecraft
    Faker::Books::Lovecraft
  end
end
