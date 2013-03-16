# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A set of header elements that correspond with values in each row
    class Header < Vector
      include Equatable

      # The header attributes
      #
      # @return [Array]
      #
      # @api private
      attr_reader :attributes

      # Initialize a Header
      #
      # @return [undefined]
      #
      # @api public
      def initialize(attributes=[])
        @attributes = attributes
        @attribute_for = Hash[@attributes.each_with_index.map.to_a]
      end

      # Lookup a column in the header given a name
      #
      # @api public
      def [](attribute)
        case attribute
        when Integer
          @attributes[attribute]
        else
          @attribute_for.fetch(attribute) do |header_name|
            raise UnknownAttributeError, "the header '#{header_name}' is unknown"
          end
        end
      end
      alias :call :[]

      # Set value at index
      #
      # @example
      #   row[attribute] = value
      #
      # @api public
      def []=(attribute, value)
        self.attributes[attribute] = value
      end

      # Size of the header
      #
      # @api public
      def size
        to_ary.size
      end
      alias :length :size

      # Convert the Header into an Array
      #
      # @api public
      def to_ary
        attributes.to_a
      end

      # Check if this header is equivalent to another header
      #
      # @return [Boolean]
      #
      # @api public
      def ==(other)
        attributes === other
      end
      alias :eql? :==

      # Provide an unique hash value
      #
      # @api public
      def to_hash
        to_a.hash
      end

    end # Header
  end # Table
end # TTY
