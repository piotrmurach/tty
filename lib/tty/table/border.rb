# -*- encoding: utf-8 -*-

module TTY
  class Table

    # Abstract base class that is responsible for building the table border.
    class Border
      include Unicode

      NEWLINE = "\n"

      # The row cell widths
      #
      # @api private
      attr_reader :widths
      private :widths

      # The table row
      #
      # @api private
      attr_reader :row
      private :row

      # Instantiate a new object
      #
      # @return [Object]
      #
      # @api private
      def initialize(*)
        if self.class == Border
          raise NotImplementedError, "#{self} is an abstract class"
        else
          super
        end
      end

      # A line spanning all columns marking top of a table.
      #
      # @api private
      def top_line(options={})
        render_line self['top'],
          self['top_left']  || self['top'],
          self['top_right'] || self['top'],
          self['top_mid']
      end

      # A line spanning all columns delemeting rows in a table.
      #
      # @api private
      def separator(options={})
        render_line self['mid'],
          self['mid_left']  || self['mid'],
          self['mid_right'] || self['mid'],
          self['mid_mid']
      end

      # A line spanning all columns delemeting cells in a row.
      #
      # @api private
      def row_line
        self['left'] + row.join(self['right']) + self['right'] + NEWLINE
      end

      # A line spannig all columns marking bottom of a table.
      #
      # @api private
      def bottom_line
        render_line self['bottom'],
          self['bottom_left']  || self['bottom'],
          self['bottom_right'] || self['bottom'],
          self['bottom_mid']
      end

      protected

      # Generate a border string
      #
      # @param [String] line
      #
      # @return [String]
      #
      # @api private
      def render_line(line, left, right, intersection)
        as_unicode do
          left + widths.map { |width| line * width }.join(intersection) + right + NEWLINE
        end
      end

    end # Border
  end # Table
end # TTY
