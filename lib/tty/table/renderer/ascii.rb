# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Renderer
      class ASCII < Basic

        def render(table)
          super table, TTY::Table::Border::ASCII
        end

      end # ASCII
    end # Renderer
  end # Table
end # TTY
