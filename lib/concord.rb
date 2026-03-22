# frozen_string_literal: true

require 'adamantium'
require 'equalizer'

# A mixin to define a composition
class Concord < Module
  include Equalizer.new(:names)
  include Adamantium::Flat

  # The maximum number of objects the hosting class is composed of
  MAX_NR_OF_OBJECTS = 3

  # Return names
  #
  # @return [Enumerable<Symbol>]
  #
  # @api private
  #
  attr_reader :names

  private

  # Initialize object
  #
  # @return [undefined]
  #
  # @api private
  #
  def initialize(*names) # rubocop:disable Lint/MissingSuper
    raise "Composition of more than #{MAX_NR_OF_OBJECTS} objects is not allowed" if names.length > MAX_NR_OF_OBJECTS

    @names = names
    @module = Module.new
    define_initialize
    define_readers
    define_equalizer
  end

  # Hook run when module is included
  #
  # @return [undefined]
  #
  # @api private
  #
  def included(descendant)
    descendant.include(@module)
  end

  # Define initialize method on the generated module
  #
  # @return [undefined]
  #
  # @api private
  #
  def define_initialize
    body = names.map { |name| "@#{name} = #{name}" }.join('; ')
    source = "def initialize(#{names.join(', ')}); #{body}; end"
    @module.class_eval(source)
  end

  # Define attribute readers on the generated module
  #
  # @return [undefined]
  #
  # @api private
  #
  def define_readers
    attribute_names = names
    @module.class_eval do
      attr_reader(*attribute_names)
      protected(attribute_names)
    end
  end

  # Define equalizer on the generated module
  #
  # @return [undefined]
  #
  # @api private
  #
  def define_equalizer
    return if @names.empty?

    @module.include(Equalizer.new(*@names, inspect: false))
    define_pattern_matching
    define_cmp
  end

  # Define deconstruct and deconstruct_keys on the generated module
  #
  # @return [undefined]
  #
  # @api private
  #
  def define_pattern_matching
    @module.class_eval do
      def deconstruct
        equalizer_keys.map { |key| instance_variable_get(:"@#{key}") }
      end

      def deconstruct_keys(requested)
        subset = requested.nil? ? equalizer_keys : equalizer_keys & requested
        subset.to_h { |key| [key, instance_variable_get(:"@#{key}")] }
      end
    end
  end

  # Define cmp? on the generated module
  #
  # @return [undefined]
  #
  # @api private
  #
  def define_cmp
    @module.class_eval do
      def cmp?(comparator, other)
        equalizer_keys.all? do |key|
          ivar = :"@#{key}"
          instance_variable_get(ivar).public_send(comparator, other.instance_variable_get(ivar))
        end
      end
      private :cmp?
    end
  end

  # Mixin for public attribute readers
  class Public < self
    # Hook called when module is included
    #
    # @param [Class,Module] descendant
    #
    # @return [undefined]
    #
    # @api private
    #
    def included(descendant)
      super
      attribute_names = @names
      descendant.class_eval do
        attribute_names.each { |name| public(name) }
      end
    end
  end
end
