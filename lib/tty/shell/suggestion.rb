# encoding: utf-8

module TTY
  # A class responsible for shell prompt interactions.
  class Shell
    # A class representing a suggestion
    class Suggestion
      DEFAULT_INDENT = 8

      SINGLE_TEXT    = 'Did you mean this?'

      PLURAL_TEXT    = 'Did you mean one of these?'

      # Number of spaces
      #
      # @api public
      attr_reader :indent

      # Text for a single suggestion
      #
      # @api public
      attr_reader :single_text

      # Text for multiple suggestions
      #
      # @api public
      attr_reader :plural_text

      # Initialize a Suggestion
      #
      # @api public
      def initialize(options = {})
        @indent      = options.fetch(:indent) { DEFAULT_INDENT }
        @single_text = options.fetch(:single_text) { SINGLE_TEXT }
        @plural_text = options.fetch(:plural_text) { PLURAL_TEXT }
        @suggestions = []
        @comparator  = Distance.new
      end

      # Suggest matches out of possibile strings
      #
      # @param [String] message
      #
      # @param [Array[String]] possibilities
      #
      # @api public
      def suggest(message, possibilities)
        distances        = measure_distances(message, possibilities)
        minimum_distance = distances.keys.min
        max_distance     = distances.keys.max

        if minimum_distance < max_distance
          @suggestions = distances[minimum_distance].sort
        end
        evaluate
      end

      private

      # Measure distances between messag and possibilities
      #
      # @param [String] message
      #
      # @param [Array[String]] possibilities
      #
      # @return [Hash]
      #
      # @api private
      def measure_distances(message, possibilities)
        distances = Hash.new { |hash, key| hash[key] = [] }

        possibilities.each do |possibility|
          distances[comparator.distance(message, possibility)] << possibility
        end
        distances
      end

      # Build up a suggestion string
      #
      # @param [Array[String]] suggestions
      #
      # @return [String]
      #
      # @api private
      def evaluate
        return suggestions if suggestions.empty?
        if suggestions.one?
          build_single_suggestion
        else
          build_multiple_suggestions
        end
      end

      # @api private
      def build_single_suggestion
        suggestion = ''
        suggestion << single_text + "\n"
        suggestion << (' ' * indent + suggestions.first)
      end

      # @api private
      def build_multiple_suggestions
        suggestion = ''
        suggestion << plural_text + "\n"
        suggestion << suggestions.map do |sugest|
          ' ' * indent + sugest
        end.join("\n")
      end

      # Distance comparator
      #
      # @api private
      attr_reader :comparator

      # Reference to the current shell
      #
      # @api private
      attr_reader :shell

      # Possible suggestions
      #
      # @api private
      attr_reader :suggestions
    end # Suggestion
  end # Shell
end # TTY
