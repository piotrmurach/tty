# -*- encoding: utf-8 -*-

module TTY
  class Shell
    class Question

      # A class representing String modifications.
      class Modifier

        attr_reader :modifiers
        private :modifiers

        # Initialize a Modifier
        #
        # @api public
        def initialize(*modifiers)
          @modifiers = *modifiers
        end

        # Change supplied value according to the given string transformation.
        # Valid settings are:
        #
        # @param [String] value
        #   the string to be modified
        #
        # @return [String]
        #
        # @api private
        def apply_to(value)
          modifiers.inject(value) do |result, mod|
            result = Modifier.letter_case mod, result
            result = Modifier.whitespace mod, result
          end
        end

        # Changes letter casing in a string according to valid modifications.
        # For invalid modification option the string is preserved.
        #
        # @param [Symbol] mod
        #  the modification to change the string
        #
        # @option mod [Symbol] :up        change to upper case
        # @option mod [Symbol] :upcase    change to upper case
        # @option mod [Symbol] :uppercase change to upper case
        # @option mod [Symbol] :down      change to lower case
        # @option mod [Symbol] :downcase  change to lower case
        # @option mod [Symbol] :capitalize change all words to start with uppercase case letter
        #
        # @return [String]
        #
        # @api public
        def self.letter_case(mod, value)
          case mod
          when /^:?up(per)?(case)?$/
            value.upcase
          when :down, :downcase, :lowercase
            value.downcase
          when :capitalize
            value.capitalize
          else
            value
          end
        end

        # Changes whitespace in a string according to valid modifications.
        #
        # @param [Symbol] mod
        #   the modification to change the string
        #
        # @option mod [String] :trim, :strip
        #   remove whitespace for the start and end
        # @option mod [String] :chomp     remove record separator from the end
        # @option mod [String] :collapse  remove any duplicate whitespace
        # @option mod [String] :remove    remove all whitespace
        #
        # @api public
        def self.whitespace(mod, value)
          case mod
          when :trim, :strip
            value.strip
          when :chomp
            value.chomp
          when :collapse
            value.gsub(/\s+/, ' ')
          when :remove
            value.gsub(/\s+/, '')
          else
            value
          end
        end

      end # Modifier

    end # Question
  end # Shell
end # TTY
