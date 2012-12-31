# -*- encoding: utf-8 -*-

module TTY
  class Table
    class Border

      # A class that represents no border.
      class Null < Border

        # A stub top line
        #
        # @api private
        def top_line
          nil
        end

        # A stub separator line
        #
        # @api private
        def separator
          nil
        end

        # A line spanning all columns delemited by space character.
        #
        # @return [String]
        #
        # @api private
        def row_line
          row.join(' ')
        end

        # A stub bottom line
        #
        # @api private
        def bottom_line
          nil
        end

      end # Null
    end # Border
  end # Table
end # TTY
