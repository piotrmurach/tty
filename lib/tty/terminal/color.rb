# encoding: utf-8

module TTY
  class Terminal
    # A class responsible for coloring strings.
    class Color
      # Embed in a String to clear all previous ANSI sequences.
      CLEAR      = "\e[0m"
      # The start of an ANSI bold sequence.
      BOLD       = "\e[1m"
      # The start of an ANSI underlined sequence.
      UNDERLINE  = "\e[4m"

      STYLES = %w( BOLD CLEAR UNDERLINE ).freeze

      # Escape codes for text color.
      BLACK         = "\e[30m"
      RED           = "\e[31m"
      GREEN         = "\e[32m"
      YELLOW        = "\e[33m"
      BLUE          = "\e[34m"
      MAGENTA       = "\e[35m"
      CYAN          = "\e[36m"
      WHITE         = "\e[37m"

      LIGHT_BLACK   = "\e[90m"
      LIGHT_RED     = "\e[91m"
      LIGHT_GREEN   = "\e[92m"
      LIGHT_YELLOW  = "\e[93m"
      LIGHT_BLUE    = "\e[94m"
      LIGHT_MAGENTA = "\e[95m"
      LIGHT_CYAN    = "\e[96m"

      TEXT_COLORS = (constants.grep(/^[^ON_]*/) - STYLES).freeze

      # Escape codes for background color.
      ON_BLACK         = "\e[40m"
      ON_RED           = "\e[41m"
      ON_GREEN         = "\e[42m"
      ON_YELLOW        = "\e[43m"
      ON_BLUE          = "\e[44m"
      ON_MAGENTA       = "\e[45m"
      ON_CYAN          = "\e[46m"
      ON_WHITE         = "\e[47m"

      ON_LIGHT_BLACK   = "\e[100m"
      ON_LIGHT_RED     = "\e[101m"
      ON_LIGHT_GREEN   = "\e[102m"
      ON_LIGHT_YELLOW  = "\e[103m"
      ON_LIGHT_BLUE    = "\e[104m"
      ON_LIGHT_MAGENTA = "\e[105m"
      ON_LIGHT_CYAN    = "\e[106m"

      BACKGROUND_COLORS = constants.grep(/^ON_*/).freeze

      attr_reader :enabled

      # Initialize a Terminal Color
      #
      # @api public
      def initialize(enabled = false)
        @enabled = enabled
      end

      # Disable coloring of this terminal session
      #
      # @api public
      def disable!
        @enabled = false
      end

      # Check if coloring is on
      #
      # @return [Boolean]
      #
      # @api public
      def enabled?
        @enabled
      end

      # Apply ANSI color to the given string.
      #
      # @param [String] string
      #   text to add ANSI strings
      #
      # @param [Array[Symbol]] colors
      #
      # @example
      #   apply "text", :yellow, :on_green, :underline
      #
      # @return [String]
      #
      # @api public
      def set(string, *colors)
        validate(*colors)
        ansi_colors = colors.map { |color| lookup(color) }
        "#{ansi_colors.join}#{string}#{CLEAR}"
      end

      # Same as instance method.
      #
      # @return [undefined]
      #
      # @api public
      def self.set(string, *colors)
        new.set(string, *colors)
      end

      # Remove color codes from a string.
      #
      # @param [String] string
      #
      # @return [String]
      #
      # @api public
      def remove(string)
        string.to_s.gsub(/(\[)?\033(\[)?[;?\d]*[\dA-Za-z](\])?/, '')
      end

      # Return raw color code without embeding it into a string.
      #
      # @return [Array[String]]
      #   ANSI escape codes
      #
      # @api public
      def code(*colors)
        validate(*colors)
        colors.map { |color| lookup(color) }
      end

      # All ANSI color names as strings.
      #
      # @return [Array[String]]
      #
      # @api public
      def names
        (STYLES + BACKGROUND_COLORS + TEXT_COLORS).map { |col| col.to_s.downcase }
      end

      protected

      # Find color representation.
      #
      # @api private
      def lookup(color)
        self.class.const_get(color.to_s.upcase)
      end

      # @api private
      def validate(*colors)
        return if colors.all? { |color| names.include?(color.to_s) }
        raise ArgumentError, 'Bad color or unintialized constant, ' \
          " valid colors are: #{names.join(', ')}."
      end
    end # Color
  end # Terminal
end # TTY
