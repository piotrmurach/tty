# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class representing table orientation
    class Orientation

      class Horizontal < Orientation

        def transform(table)
          if table.orientation.name == :horizontal
            table.rotate
          end
        end

      end # Horizontal

   end # Orientation
  end # Table
end # TTY
