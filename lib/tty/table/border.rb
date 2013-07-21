# -*- encoding: utf-8 -*-

module TTY
  class Table

    # Abstract base class that is responsible for building the table border.
    class Border
      include Unicode
      include TTY::Equatable

      EMPTY_CHAR = ''.freeze

      SPACE_CHAR = ' '.freeze

      # Represent a separtor on each row
      EACH_ROW = :each_row

      # The row field widths
      #
      # @api private
      attr_reader :widths
      private :widths

      # The table row
      #
      # @api private
#       attr_reader :row
#       private :row

      # The table custom border characters
      attr_reader :border

      class << self
        # Store characters for border
        #
        # @api private
        attr_accessor :characters
      end

      # Instantiate a new object
      #
      # @param [Array] column_widths
      #   the table column widths
      #
      # @param [BorderOptions] options
      #
      # @return [Object]
      #
      # @api private
      def initialize(column_widths, options=nil)
        if self.class == Border
          raise NotImplementedError, "#{self} is an abstract class"
        else
          @widths = column_widths
          @border = TTY::Table::BorderOptions.from options
        end
      end

      # Define border characters
      #
      # @param [Hash] characters
      #   the border characters
      #
      # @return [Hash]
      #
      # @api public
      def self.def_border(characters=(not_set=true), &block)
        return self.characters = characters if !not_set

        dsl = TTY::Table::BorderDSL.new(&block)
        self.characters = dsl.characters
      end

      # Retrive individula character by type
      #
      # @param [String] type
      #   the character type
      #
      # @return [String]
      #
      # @api private
      def [](type)
        characters = self.class.characters
        chars = border.nil? ? characters : characters.merge(border.characters)
        chars[type] || EMPTY_CHAR
      end

      # Check if border color is set
      #
      # @return [Boolean]
      #
      # @api public
      def color?
        border && border.style
      end

      # Set color on characters
      #
      # @param [Symbol] color
      #
      # @param [Array[String]] array of strings
      #
      # @return [Array[String]]
      #
      # @api public
      def self.set_color(color, *strings)
        strings.map { |string| TTY.terminal.color.set(string, color) }
      end

      # A line spanning all columns marking top of a table.
      #
      # @return [String]
      #
      # @api private
      def top_line
        (result = render(:top)).empty? ? nil : result
      end

      # A line spanning all columns delemeting rows in a table.
      #
      # @return [String]
      #
      # @api private
      def separator
        (result = render(:mid)).empty? ? nil : result
      end

      # A line spanning all columns delemeting fields in a row.
      #
      # @return [String]
      #
      # @api public
      def row_line(row)
        right_char  = self['right']
        left_char   = self['left']
        center_char = self['center']

        if color?
          right_char, center_char, left_char = Border.set_color(border.style, right_char, center_char, left_char)
        end

        result = row_heights(row, left_char, center_char, right_char)
        result.empty? ? "" : result
      end

      # Separate multiline string into individual rows with border.
      #
      # @param [String] left_char
      #
      # @param [String] center_char
      #
      # @param [String] right_char
      #
      # @api private
      def row_heights(row, left_char, center_char, right_char)
        if row.size > 0
          row.height.times.map do |line|
            row_height_line(row, line, left_char, center_char, right_char)
          end.join("\n")
        else
          left_char + right_char
        end
      end

      # Generate border for a given multiline row
      #
      # @param [Integer] line
      #  the index for current line inside multiline
      #
      # @return [String]
      #
      # @api private
      def row_height_line(row, line, left_char, center_char, right_char)
        left_char + row.fields.each_with_index.map do |field, index|
          (field.lines[line] || "").ljust(widths[index])
        end.join(center_char) + right_char
      end

      # A line spannig all columns marking bottom of a table.
      #
      # @return [String]
      #
      # @api private
      def bottom_line
        (result = render(:bottom)).empty? ? nil : result
      end

      protected

      # Generate particular border type
      #
      # @param [String] type
      #  border type one of [:top, :bottom, :mid]
      #
      # @api private
      def render(type)
        type = type.to_s
        border_char = self[type]
        line = render_line(border_char,
          self["#{type}_left"]  || border_char,
          self["#{type}_right"] || border_char,
          self["#{type}_mid"])

        line = Border.set_color(border.style, line) if color?
        line
      end

      # Generate a border string
      #
      # @param [String] line
      #
      # @return [String]
      #
      # @api private
      def render_line(line, left, right, intersection)
        as_unicode do
          left + widths.map { |width| line * width }.join(intersection) + right
        end
      end

    end # Border
  end # Table
end # TTY
