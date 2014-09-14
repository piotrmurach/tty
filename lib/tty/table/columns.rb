# encoding: utf-8

module TTY
  class Table
    # A class responsible for enforcing column constraints.
    #
    # Used internally by {Renderer::Basic} to enforce correct column widths.
    #
    # @api private
    class Columns

      attr_reader :table

      attr_reader :renderer

      MIN_WIDTH = 1

      BORDER_WIDTH = 1

      # Initialize a Columns
      #
      # @param [TTY::Table::Renderer] renderer
      #
      # @api public
      def initialize(renderer)
        @renderer = renderer
        @table    = renderer.table
      end

      # Estimate outside border size
      #
      # @return [Integer]
      #
      # @api public
      def outside_border_size
        renderer.border_class == TTY::Table::Border::Null ? 0 : 2
      end

      # Total border size
      #
      # @return [Integer]
      #
      # @api public
      def border_size
        BORDER_WIDTH * (table.column_size - 1) + outside_border_size
      end

      # Estimate minimum table width to be able to display content
      #
      # @return [Integer]
      #
      # @api public
      def minimum_width
        table.column_size * MIN_WIDTH + border_size
      end

      # Return column's natural unconstrained widths
      #
      # @return [Integer]
      #
      # @api public
      def natural_width
        renderer.column_widths.inject(0, &:+) + border_size
      end

      # Return the constrained column widths.
      #
      # Account for table field widths and any user defined
      # constraints on the table width.
      #
      # @api public
      def enforce
        assert_minimum_width

        unless renderer.padding.empty?
          renderer.column_widths = adjust_padding
        end

        if natural_width <= renderer.width
          renderer.column_widths = expand if renderer.resize
        else
          if renderer.resize
            renderer.column_widths = shrink
          else
            rotate
            renderer.column_widths = ColumnSet.widths_from(table)
          end
        end
      end

      # Adjust column widths to account for padding whitespace
      #
      # @api private
      def adjust_padding
        padding     =  renderer.padding
        column_size = table.column_size

        (0...column_size).reduce([]) do |lengths, col|
          lengths + [padding.left + renderer.column_widths[col] + padding.right]
        end
      end

      # Rotate table to vertical orientation and print information to stdout
      #
      # @api private
      def rotate
        TTY.shell.warn 'The table size exceeds the currently set width.' \
                       'To avoid error either. Defaulting to vertical ' \
                       'orientation.'
        table.orientation = :vertical
        table.rotate
      end

      # Expand column widths to match the requested width
      #
      # @api private
      def expand
        column_size = table.column_size
        ratio       = ((renderer.width - natural_width) / column_size.to_f).floor

        widths = (0...column_size).reduce([]) do |lengths, col|
          lengths + [renderer.column_widths[col] + ratio]
        end
        distribute_extra_width(widths)
      end

      # Shrink column widths to match the requested width
      #
      # @api private
      def shrink
        column_size = table.column_size
        ratio       = ((natural_width - renderer.width) / column_size.to_f).ceil

        widths = (0...column_size).reduce([]) do |lengths, col|
          lengths + [renderer.column_widths[col] - ratio]
        end
        distribute_extra_width(widths)
      end

      # Assert minimum width for the table content
      #
      # @raise [TTY::ResizeError]
      #
      # @api private
      def assert_minimum_width
        width = renderer.width
        return unless width <= minimum_width
        fail ResizeError, "Table's width is too small to contain the content " \
                          "(min width #{minimum_width}, currently set #{width})"
      end

      # Distribute remaining width to meet the total width requirement.
      #
      # @param [Array[Integer]] widths
      #
      # @api private
      def distribute_extra_width(widths)
        column_size     = table.column_size
        extra_width     = renderer.width - (widths.reduce(:+) + border_size)
        per_field_width = extra_width / column_size
        remaining_width = extra_width % column_size
        extra = [1] * remaining_width + [0] * (column_size - remaining_width)

        widths.map.with_index do |width, index|
          width + per_field_width + extra[index]
        end
      end
    end # Columns
  end # Table
end # TTY
