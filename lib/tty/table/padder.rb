# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class responsible for processing table field padding
    class Padder
      include TTY::Equatable

      attr_reader :padding

      def initialize(padding)
        @padding = padding
      end

      def self.parse(value)
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

      def top
        @padding[0].to_i
      end

      def right
        @padding[1].to_i
      end

      def bottom
        @padding[2].to_i
      end

      def left
        @padding[3].to_i
      end

      def empty?
        padding.empty?
      end

    end # Padder
  end # Table
end # TTY
