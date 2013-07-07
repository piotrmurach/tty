# -*- encoding: utf-8 -*-

module TTY
  class Table
    class Renderer
      class Unicode < Basic

        def initialize(table, options={})
          super(table, options.merge(:border_class => TTY::Table::Border::Unicode))
        end

      end # Unicode
    end # Renderer
  end # Table
end # TTY
