# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class responsible for enforcing column constraints
    class Columns

      attr_reader :table

      attr_reader :renderer

      MIN_WIDTH = 1

      BORDER_WIDTH = 1

      # Initialize a Columns
      #
      # @param [TTY::Table::Renderer]
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

      # Return the constrained column widths. Account for table field widths
      # and any user defined constraints on the table width.
      #
      # @api public
      def enforce
        assert_minimum_width

        if natural_width < renderer.width && renderer.resize
          ratio = (renderer.width - natural_width) / table.column_size.to_f

          widths = (0...table.column_size).reduce([]) do |lengths, col|
            lengths + [(renderer.column_widths[col] + ratio).floor]
          end

          widths = distribute_extra_width(widths)
          renderer.column_widths = widths
        end

        if natural_width > renderer.width
          # TODO: try autoresize before rotating

          TTY.shell.warn 'The table size exceeds the currently set width.' +
          'To avoid error either. Defaulting to vertical orientation.'

          table.orientation= :vertical
          table.rotate
          renderer.column_widths = ColumnSet.widths_from(table)
        end
      end

      # Assert minimum width for the table content
      #
      # @raise [TTY::ResizeError]
      #
      # @api private
      def assert_minimum_width
        if renderer.width <= minimum_width
          raise ResizeError,
            "Table's width is too small to contain the content " +
            "(min width #{minimum_width}, currently set #{renderer.width})"
        end
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

        widths.map do |width|
          extra = remaining_width <= 0 ? 0 : 1
          remaining_width -= 1
          width + per_field_width + extra
        end
      end

    end # Columns
  end # Table
end # TTY
