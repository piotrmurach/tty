# encoding: utf-8

module TTY
  # This class represents a mathematical vector.
  class Vector
    include Enumerable, Equatable

    attr_reader :elements
    protected :elements

    # Utility method to instantiate a Vector
    #
    # @param [Array] *array
    #
    # @return [Vector]
    #
    # @api public
    def self.[](*array)
      new(array)
    end

    # Instantiate a Vector
    #
    # @param [Array] array
    #
    # @return [undefined]
    #
    # @api public
    def initialize(array = [])
      @converter = Necromancer.new
      @elements = @converter.convert(array).to(:array, strict: true)
    end

    # Return element at index.
    #
    # @param [Integer] indx
    #   index of an element
    #
    # @return [Object]
    #   a value of an element
    #
    # @api public
    def [](indx)
      elements[indx]
    end
    alias at      []
    alias element []

    # Set a value of the element for the given index.
    #
    # @param [Integer] indx
    #   an index of an element
    #
    # @param [Object] value
    #   a value to be set
    #
    # @return [Object]
    #
    # @api public
    def []=(indx, value)
      elements[indx] = value
    end
    alias set_element []=

    # Iterate over each element in the vector
    #
    # @example
    #   vec = Vector[1,2,3]
    #   vec.each { |element| ... }
    #
    # @return [self]
    #
    # @api public
    def each
      return to_enum unless block_given?
      to_ary.each { |element| yield element }
      self
    end

    # Convert to array
    #
    #  @return [Array]
    #
    # @api public
    def to_ary
      @elements
    end

    # Check if there are not elements.
    #
    # @return [Boolean]
    #
    # @api public
    def empty?
      to_ary.empty?
    end

    # Check number of elements.
    #
    # @return [Integer]
    #
    # @api public
    def size
      to_ary.size
    end
    alias :length :size

    # Return the vector elements in an array.
    #
    # @return [Array]
    #
    # @api public
    def to_a
      to_ary.dup
    end
  end # Vector
end # TTY
