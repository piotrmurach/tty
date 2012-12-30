# -*- encoding: utf-8 -*-

module TTY

  # A class responsible for text manipulations
  class Text

    SPACE = " ".freeze

    NEWLINE = "\n".freeze

    DEFAULT_WIDTH = 80.freeze


    # Specifies the split mode for words
    def split_mode
    end

    # Wrap a text into lines no longer than :line_width width.
    #
    # @param [String] text
    #   the text to be wrapped
    #
    # @overload wrap(text, value)
    #   wraps text at given value
    #
    #   @param [Integer] value
    #
    # @overload wrap(text, value, options)
    #   @param [Integer] value
    #   @param [Hash] options
    #   @option options [Symbol] :indent the indentation
    #
    # @example
    #   wrap("Some longish text", 8)
    #    # => "Some\nlongish\ntext"
    #
    #   wrap("Some longish text", 8, :indent => 4)
    #    # => >    Some
    #         >    longish
    #         >    text
    #
    # @api public
    def self.wrap(text, *args)
      Wrapping.new(text, *args).wrap
    end

  end # Text
end # TTY
