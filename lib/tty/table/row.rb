# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class that represents a row in a table.
    class Row < Vector
      include Equatable

      # The row attributes
      #
      # @return [Array]
      #
      # @api private
      attr_reader :attributes

      # The row data
      #
      # @return [Hash]
      #
      # @api private
      attr_reader :data

      # Initialize a Row
      #
      # @example
      #   row = new TTY::Table::Row.new [1,2,3]
      #   row[1]  # => 2
      #
      #   row = new TTY::Table::Row.new [1,2,3], :attributes => %w[a b c]
      #   row[0]   # => 1
      #   row['a'] # => 1
      #
      #   row = new TTY::Table::Row.new {"a": 1, "b": 2, "c": 3}
      #   row[0]   # => 1
      #   row['a'] # => 1
      #
      # @param [#to_ary] data
      #   the row data
      #
      # @return [undefined]
      #
      # @api public
      def initialize(data, header=nil)
        case data
        when Array
          @attributes = header || (0...data.length).to_a
          @data = Hash[@attributes.zip(data)]
        when Hash
          @data = data.dup
          @attributes = header || data.keys
        end
      end

      # Lookup a value in the row given an attribute allowing for Array or
      # Hash like indexing
      #
      # @exmaple
      #   row[1]
      #   row[:id]
      #   row.call(:id)
      #
      # @api public
      def [](attribute)
        case attribute
        when Integer
          data[attributes[attribute]]
        else
          data.fetch(attribute) do |name|
            raise UnknownAttributeError, "the attribute #{name} is unkown"
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
        case attribute
        when Integer
          self.data[attributes[attribute]] = value
        else
          self.data[attribute] = value
          self.attributes << attribute unless attributes.include?(attribute)
        end
      end

      # Number of data items in a row
      #
      # @return [Integer]
      #
      # @api public
      def size
        data.size
      end
      alias :length :size

      # Convert the Row into Array
      #
      # @example
      #   array = row.to_ary
      #
      # @return [Array]
      #
      # @api public
      def to_ary
        data.values_at(*attributes)
      end

      # Convert the Row into hash
      #
      # @return [Hash]
      #
      # @api public
      def to_hash
        data.dup
      end

      # Check if this row is equivalent to another row
      #
      # @return [Boolean]
      #
      # @api public
      def ==(other)
        to_a == other.to_a
      end
      alias :eql? :==

      # Provide a unique hash value. If a row contains the same data as another
      # row, they will hash to the same value.
      #
      # @api public
      def hash
        to_a.hash
      end
    end # Row

  end # Table
end # TTY
