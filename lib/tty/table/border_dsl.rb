# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class responsible for bulding and modifying border
    class BorderDSL

      attr_reader :characters

      # Initialize a BorderDSL
      #
      # @param [Hash] characters
      #   the border characters
      #
      # @return [undefined]
      #
      # @api private
      def initialize(characters=nil)
        @characters = characters || {}
      end

      # Set top border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def top(value)
        @characters['top'] = value
      end

      # Set top middle border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def top_mid(value)
        @characters['top_mid'] = value
      end

      # Set top left corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def top_left(value)
        @characters['top_left'] = value
      end

      # Set top right corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def top_right(value)
        @characters['top_right'] = value
      end

      # Set bottom border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def bottom(value)
        @characters['bottom'] = value
      end

      # Set bottom middle border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def bottom_mid(value)
        @characters['bottom_mid'] = value
      end

      # Set bottom left corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def bottom_left(value)
        @characters['bottom_left'] = value
      end

      # Set bottom right corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def bottom_right(value)
        @characters['bottom_right'] = value
      end

      # Set middle border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def mid(value)
        @characters['mid'] = value
      end

      # Set middle border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def mid_mid(value)
        @characters['mid_mid'] = value
      end

      # Set middle left corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def mid_left(value)
        @characters['mid_left'] = value
      end

      # Set middle right corner border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def mid_right(value)
        @characters['mid_right'] = value
      end

      # Set left border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def left(value)
        @characters['left'] = value
      end

      # Set right border character
      #
      # @param [String] value
      #   the character value
      #
      # @return [undefined]
      #
      # @api public
      def right(value)
        @characters['right'] = value
      end

    end # BorderDSL

  end # Table
end # TTY
