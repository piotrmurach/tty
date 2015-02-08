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
  end # Text
end # TTY
