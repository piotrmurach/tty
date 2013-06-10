# -*- encoding: utf-8 -*-

module TTY
  class Text

    # A class responsible for string comparison
    class Distance
      include Unicode

      attr_reader :first

      attr_reader :second

      # Initalize a Distance
      #
      # @param [String] first
      #   the first string for comparision
      #
      # @param [String] second
      #  the second string for comparison
      #
      # @api private
      def initialize(first, second, *args)
        options = Utils.extract_options!(args)
        @first = first.to_s
        @second = second.to_s
        # TODO: add option to ignore case
      end

      # Calculate the optimal string alignment distance
      #
      # @api private
      def distance
        distances = []
        rows      = first.length
        cols      = second.length

        0.upto(rows) do |index|
          distances << [index] + [0] * cols
        end
        distances[0] = 0.upto(cols).to_a

        1.upto(rows) do |first_index|
          1.upto(cols) do |second_index|
            first_char  = first[first_index - 1]
            second_char = second[second_index - 1]
            cost        = first_char == second_char ? 0 : 1

            distances[first_index][second_index] = [
              distances[first_index - 1][second_index], # deletion
              distances[first_index][second_index - 1],     # insertion
              distances[first_index - 1][second_index - 1]  # substitution
            ].min + cost

            if first_index > 1 && second_index > 1
              first_previous_char = first[first_index - 2]
              second_previous_char = second[second_index - 2]
              if first_char == second_previous_char && second_char == first_previous_char
                distances[first_index][second_index] = [
                  distances[first_index][second_index],
                  distances[first_index - 2][second_index - 2] + 1 # transposition
                ].min
              end
            end

          end
        end
        distances[rows][cols]
      end

    end # Distance
  end # Text
end # TTY
