# -*- encoding: utf-8 -*-

module TTY
  # A class responsible for shell prompt interactions.
  class Shell

    # A class representing a suggestion
    class Suggestion

      # @api private
      attr_reader :shell
      private :shell

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

      DEFAULT_INDENT = 8

      SINGLE_TEXT    = 'Did you mean this?'

      PLURAL_TEXT    = 'Did you mean one of these?'

      # Initialize a Suggestion
      #
      # @api public
      def initialize(options={})
        @indent      = options.fetch(:indent) { DEFAULT_INDENT }
        @single_text = options.fetch(:single_text) { SINGLE_TEXT }
        @plural_text = options.fetch(:plural_text) { PLURAL_TEXT }
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
          suggestions = distances[minimum_distance].sort
          evaluate(suggestions)
        else
          nil
        end
      end

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
          distances[Text.distance(message, possibility)] << possibility
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
      def evaluate(suggestions)
        suggestion = ""
        if suggestions.one?
          suggestion << single_text + "\n"
          suggestion << (" " * indent + suggestions.first)
        else
          suggestion << plural_text + "\n"
          suggestion << suggestions.map { |suggestion| " " * indent + suggestion }.join("\n")
        end
      end

    end # Suggestion
  end # Shell
end # TTY
