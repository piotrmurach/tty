# -*- encoding: utf-8 -*-

module TTY
  class Text

    # A class responsible for text truncation operations
    class Truncation
      include Unicode

      DEFAULT_TRAILING = '…'.freeze

      DEFAULT_TRUNCATION_LENGTH = 30.freeze

      attr_reader :text

      attr_reader :length

      attr_reader :separator

      attr_reader :trailing

      attr_reader :escape

      # Initialize a Truncation
      #
      # @param [String] text
      #   the text to be truncated
      #
      # @overload new(text, value)
      #   truncates text at given value
      #
      #   @param [Integer] value
      #
      # @overload new(text, value, options)
      #   @param [Integer] value
      #
      #   @param [Hash] options
      #   @option options [Symbol] :length    the desired length
      #   @option options [Symbol] :separator the character for splitting words
      #   @option options [Symbol] :trailing  the character for ending sentence
      #   @option options [Symbol] :escape    remove ANSI escape sequences
      #
      # @api private
      def initialize(text, *args)
        options    = Utils.extract_options!(args)
        @text      = text
        @length    = options.fetch(:length) { DEFAULT_TRUNCATION_LENGTH }
        @length    = args[0] unless args.empty?
        @separator = options.fetch(:separator) { nil }
        @trailing  = options.fetch(:trailing) { DEFAULT_TRAILING }
        @escape    = options.fetch(:escape) { true }
      end

      # Truncate a text
      #
      # @see TTY::Text.truncate
      #
      # @api private
      def truncate
        return text unless length && length > 0

        as_unicode do
          chars = (escape ? escape_text : text).chars.to_a
          return chars.join if chars.length <= length
          stop = chars[0, length_without_trailing].rindex(separator)

          chars[0, stop || length_without_trailing].join + trailing
        end
      end

      private

      # Strip ANSI characters from the text
      #
      # @param [String] text
      #
      # @return [String]
      #
      # @api private
      def escape_text
        TTY.terminal.color.remove text.dup
      end

      # Leave space for the trailing characters
      #
      # @return [Integer]
      #
      # @api private
      def length_without_trailing
        as_unicode do
          trailing_size = trailing.chars.to_a.size
          length - trailing_size
        end
      end

    end # Truncation
  end # Text
end # TTY
