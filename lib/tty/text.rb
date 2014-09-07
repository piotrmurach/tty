# encoding: utf-8

module TTY
  # A class responsible for text manipulations
  class Text
    SPACE = ' '

    NEWLINE = "\n"

    DEFAULT_WIDTH = 80.freeze

    # Specifies the split mode for words
    def split_mode
    end

    # Calculate the distance between strings
    #
    # @param [String] first
    #   the first string for comparison
    #
    # @param [String] second
    #   the second string for comparison
    #
    # @example
    #   distance("which", "witch")  # => 2
    #
    # @api public
    def self.distance(first, second, *args)
      Distance.new(first, second, *args).distance
    end

    # Wrap a text into lines no longer than provided length
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
    #   wrap("Some longish text", length: 8)
    #    # => "Some\nlongish\ntext"
    #
    #   wrap("Some longish text", 8, indent: 4)
    #    # => >    Some
    #         >    longish
    #         >    text
    #
    # @api public
    def self.wrap(text, *args)
      Wrapping.new(text, *args).wrap
    end

    # Truncate a text at a given length (defaults to 30)
    #
    # @param [String] text
    #   the text to be truncated
    #
    # @overload truncate(text, value)
    #   truncates text at given value
    #
    #   @param [Integer] value
    #
    # @overload truncate(text, value, options)
    #   @param [Integer] value
    #   @param [Hash] options
    #   @option options [Symbol] :separator the separation character
    #   @option options [Symbol] :trailing  the trailing characters
    #
    # @example
    #   truncate("The sovereignest thing on earth is parmacetti for an inward bruise.")
    #   # => "The sovereignest thing on ear…"
    #
    #   truncate("The sovereignest thing on earth is parmacetti for an inward bruise.", length: 20)
    #   # => "The sovereignest th…"
    #
    #   truncate("The sovereignest thing on earth is parmacetti for an inward bruise.", length: 20, separator: ' ' )
    #   # => "The sovereignest…"
    #
    #   truncate("The sovereignest thing on earth is parmacetti for an inward bruise.", length: 40, trailing: '... (see more)' )
    #   # => "The sovereignest thing on... (see more)"
    #
    # @api public
    def self.truncate(text, *args)
      Truncation.new(text, *args).truncate
    end
  end # Text
end # TTY
