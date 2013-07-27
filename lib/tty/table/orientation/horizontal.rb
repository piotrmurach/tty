# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class representing table orientation
    class Orientation

      class Horizontal < Orientation

        def transform(table)
          table.rotate_horizontal
        end

      end # Horizontal

    end # Orientation
  end # Table
end # TTY
