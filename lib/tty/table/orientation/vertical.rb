# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class representing table orientation
    class Orientation

      class Vertical < Orientation

        def transform(table)
          if table.orientation.name == :vertical
            table.rotate
          end
        end

      end # Vertical

    end # Orientation
  end # Table
end # TTY
