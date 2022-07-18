# frozen_string_literal: true

require_relative '../loader'

# Source-code parser based on YARD.
class Rqb::Shell::App::Loader::Parser
  autoload(:YARD, 'yard')

  # Initialize with parseable file.
  #
  # @param [Pathname] file
  def initialize(file)
    self.file = file
    @parsed_attributes = %i[file name namespace description loader].freeze
  end

  class << self
    # Parse given file.
    #
    # @param [Pathname] file
    def parse(file)
      self.new(file).call
    end
  end

  def call
    parse_object.first&.then { |info| make(info) }
  end

  protected

  # Parsed file.
  #
  # @type [Pathname]
  attr_accessor :file

  # @return [Array<Symbol>]
  attr_reader :parsed_attributes

  # @return [Array<YARD::CodeObjects::ClassObject>]
  def parse_object
    YARD.parse(file.to_path).then do
      registry.keep_if { |object| object.files.to_h.keys.include?(file.to_path) }
    end
  end

  # @return [Struct]
  def make(info)
    {
      file: file,
      name: info.name,
      namespace: info.namespace.to_s,
      description: info.docstring,
      loader: make_loader(file, info)
    }.then { |kwargs| struct.new(**kwargs) }
  end

  # @return [Class<Struct>]
  def struct
    Struct.new(*parsed_attributes.sort, keyword_init: true)
  end

  # Get a registry of subcommands classes
  #
  # @return [Array<YARD::CodeObjects::ClassObject, YARD::CodeObjects::Base>]
  def registry
    YARD::Registry
      .all
      .keep_if { |object| object.is_a?(YARD::CodeObjects::ClassObject) }
      .keep_if { |object| object.inheritance_tree.map(&:to_s).include?(::Rqb::Cli::Command.to_s) }
  end

  # Provide a loader for given file with given info.
  #
  # @param [Pathname, String] file
  # @param [YARD::CodeObjects::ClassObject] info
  #
  # @return [Proc]
  def make_loader(file, info)
    [info.namespace, info.name].compact.join('::').then do |class_name|
      lambda do
        "(require'#{file}').then { #{class_name} }".then do |script|
          self.instance_eval(script, __FILE__, __LINE__ - 1)
        end
      end
    end
  end
end
