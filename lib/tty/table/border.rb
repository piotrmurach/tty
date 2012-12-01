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
      # @return [String]
      #
      # @api private
      def top_line
        render :top
      end

      # A line spanning all columns delemeting rows in a table.
      #
      # @return [String]
      #
      # @api private
      def separator
        render :mid
      end

      # A line spanning all columns delemeting cells in a row.
      #
      # @return [String]
      #
      # @api private
      def row_line
        self['left'] + row.join(self['right']) + self['right']
      end

      # A line spannig all columns marking bottom of a table.
      #
      # @return [String]
      #
      # @api private
      def bottom_line
        render :bottom
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
        render_line self[type],
          self["#{type}_left"]  || self[type],
          self["#{type}_right"] || self[type],
          self["#{type}_mid"]
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
