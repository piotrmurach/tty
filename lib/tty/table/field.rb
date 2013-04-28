# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class that represents a unique element in a table.
    class Field
      include Equatable

      # The value inside the field
      #
      # @api public
      attr_reader :value

      # The field value width
      #
      # @api public
      attr_reader :width

      # Number of columns this field spans. Defaults to 1.
      #
      attr_reader :colspan

      # Number of rows this field spans. Defaults to 1.
      #
      attr_reader :rowspan

      # Initialize a Field
      #
      # @example
      #   field = new TTY::Table::Field 'a1'
      #   field.value  # => a1
      #
      #   field = new TTY::Table::Field {:value => 'a1'}
      #   field.value  # => a1
      #
      #   field = new TTY::Table::Field {:value => 'a1', :align => :center}
      #   field.value  # => a1
      #   field.align  # => :center
      #
      # @api private
      def initialize(value)
        if value.class <= Hash
          options = value
          @value = options.fetch(:value)
        else
          @value = value
          options = {}
        end
        @width   = options.fetch(:width) { @value.to_s.size }
        @align   = options.fetch(:align) { :left }
        @colspan = options.fetch(:colspan) { 1 }
        @rowspan = options.fetch(:rowspan) { 1 }
      end

      # Return the width this field would normally have bar other contraints
      #
      # @api public
      def value_width
        @width
      end

      def value_height
        @height
      end

      def height
        lines.size
      end

      # Return number of lines this value spans
      #
      def lines
        value.to_s.split(/\n/)
      end

      def longest_line
        lines.max_by(&:length).size
      end

      # Render value inside this field box
      #
      # @api public
      def render
      end

      # Return field value
      #
      # @api public
      def to_s
        value
      end

    end # Field
  end # Table
end # TTY
