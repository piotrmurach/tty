# -*- encoding: utf-8 -*-

module TTY
  class Text

    # A class responsible for text wrapping operations
    class Wrapping
      include Unicode

      attr_reader :text

      attr_reader :width

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
      #
      # @api private
      def initialize(text, *args)
        options = Utils.extract_options!(args)
        @text    = text
        @width   = options.fetch(:width) { DEFAULT_WIDTH }
        @indent  = options.fetch(:indent) { 0 }
        @width   = args[0] unless args.empty?
      end

      # Wrap a text into lines no longer than width.
      #
      # @see TTY::Text#wrap
      #
      # @api private
      def wrap
        as_unicode do
          text.split(NEWLINE).map do |line|
            modified_line = wrap_line line
            indent_line modified_line
          end * NEWLINE
        end
      end

      private

      # Calculate string length without color escapes
      #
      # @api private
      def actual_length(string) #, width)
        width + (string.length - TTY.terminal.color.remove(string).length)
      end

      # Wrap line at given width
      #
      # @param [String] line
      #
      # @param [Integer] width
      #
      # @return [String]
      #
      # @api private
      def wrap_line(line) #, width)
        length = actual_length line #, width
        line.strip.gsub(/\n/,' ').squeeze(' ').
          gsub(/(.{1,#{length}})(?:\s+|$\n?)|(.{1,#{length}})/, "\\1\\2\n").strip
      end

      # Indent string by given value
      #
      # @param [String] text
      #
      # @param [Integer] indent
      #
      # @return [String]
      #
      # @api private
      def indent_line(text) #, indent)
        text.split(NEWLINE).each do |line|
          line.insert(0, SPACE * indent)
        end
      end

    end # Wrapping
  end # Text
end # TTY
