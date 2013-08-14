# -*- encoding: utf-8 -*-

module TTY
  class Text

    # A class responsible for text wrapping operations
    class Wrapping
      include Unicode

      attr_reader :text

      attr_reader :length

      attr_reader :indent

      # Initialize a Wrapping
      #
      # @param [String] text
      #   the text to be wrapped
      #
      # @overload new(text, value)
      #   wraps text at given value
      #
      #   @param [Integer] value
      #
      # @overload new(text, value, options)
      #   @param [Integer] value
      #   @param [Hash] options
      #   @option options [Symbol] :indent the indentation
      #   @option options [Symbol] :length the desired length
      #
      # @api private
      def initialize(text, *args)
        options = Utils.extract_options!(args)
        @text   = text
        @length = options.fetch(:length) { DEFAULT_WIDTH }
        @indent = options.fetch(:indent) { 0 }
        @length = args[0] unless args.empty?
      end

      # Wrap a text into lines no longer than length
      #
      # @see TTY::Text#wrap
      #
      # @api private
      def wrap
        return text unless length && length > 0

        as_unicode do
          text.split(NEWLINE, -1).map do |line|
            modified_line = wrap_line line
            indent_line modified_line
          end * NEWLINE
        end
      end

      private

      # Calculate string length without color escapes
      #
      # @param [String] string
      #
      # @api private
      def actual_length(string)
        length + (string.length - TTY.terminal.color.remove(string).length)
      end

      # Wrap line at given length
      #
      # @param [String] line
      #
      # @return [String]
      #
      # @api private
      def wrap_line(line)
        wrap_at = actual_length line
        line.strip.gsub(/\n/,' ').squeeze(' ').
          gsub(/(.{1,#{wrap_at}})(?:\s+|$\n?)|(.{1,#{wrap_at}})/, "\\1\\2\n").strip
      end

      # Indent string by given value
      #
      # @param [String] text
      #
      # @return [String]
      #
      # @api private
      def indent_line(text)
        text.split(NEWLINE).each do |line|
          line.insert(0, SPACE * indent)
        end
      end

    end # Wrapping
  end # Text
end # TTY
