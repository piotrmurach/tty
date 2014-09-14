# encoding: utf-8

module TTY
  class Table
    class Border
      # A class for a table row line chars manipulation
      class RowLine < Struct.new(:left, :center, :right)
        # Colorize characters with a given style
        #
        # @api public
        def colorize(style)
          colorized_chars = Border.set_color(style, right, center, left)
          self.right, self.center, self.left = colorized_chars
        end
      end # RowLine
    end # Border
  end # Table
end # TTY
