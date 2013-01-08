# -*- encoding: utf-8 -*-

module TTY
  class Table

    # Abstract base class that is responsible for building the table border.
    class Border
      include Unicode

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

      class << self
        # Store characters for border
        #
        # @api private
        attr_accessor :characters
      end

      # Instantiate a new object
      #
      # @return [Object]
      #
      # @api private
      def initialize(row=nil)
        if self.class == Border
          raise NotImplementedError, "#{self} is an abstract class"
        else
          @row = row
          @widths = row.map { |cell| cell.chars.to_a.size }
        end
      end

      # Define border characters
      #
      # @api public
      def self.def_border(&block)
        @characters = block
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
        self.class.characters.call[type] || ''
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

      # A line spanning all columns delemeting cells in a row.
      #
      # @return [String]
      #
      # @api private
      def row_line
        result = self['left'] + row.join(self['right']) + self['right']
        result.empty? ? nil : result
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
