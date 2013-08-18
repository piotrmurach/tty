# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class responsible for processing table field padding
    class Padder
      include TTY::Equatable

      attr_reader :padding

      # Initialize a Padder
      #
      # @api public
      def initialize(padding)
        @padding = padding
      end

      # Parse padding options
      #
      # @param [Object] value
      #
      # @return [TTY::Padder]
      #
      # @api public
      def self.parse(value = nil)
        return value if value.kind_of?(self)

        padding = if value.class <= Numeric
          [value, value, value, value]
        elsif value.nil?
          []
        elsif value.size == 2
          [value[0], value[1], value[0], value[1]]
        elsif value.size == 4
          value
        else
          raise ArgumentError, 'Wrong :padding parameter, must be an array'
        end
        new(padding)
      end

      # Top padding
      #
      # @return [Integer]
      #
      # @api public
      def top
        @padding[0].to_i
      end

      # Set top padding
      #
      # @param [Integer] val
      #
      # @api public
      def top=(value)
        @padding[0] = value
      end

      # Right padding
      #
      # @return [Integer]
      #
      # @api public
      def right
        @padding[1].to_i
      end

      # Set right padding
      #
      # @param [Integer] val
      #
      # @api public
      def right=(value)
        @padding[1] = value
      end

      # Bottom padding
      #
      # @return [Integer]
      #
      # @api public
      def bottom
        @padding[2].to_i
      end

      # Set bottom padding
      #
      # @param [Integer] value
      #
      # @api public
      def bottom=(value)
        @padding[2] = value
      end

      # Left padding
      #
      # @return [Integer]
      #
      # @api public
      def left
        @padding[3].to_i
      end

      # Set left padding
      #
      # @param [Integer] value
      #
      # @api public
      def left=(value)
        @padding[3] = value
      end

      # Check if padding is set
      #
      # @api public
      def empty?
        padding.empty?
      end

    end # Padder
  end # Table
end # TTY
