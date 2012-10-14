# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation
      class Alignment
        include TTY::Coercion

        LEFT = :left.freeze

        RIGHT = :right.freeze

        CENTER = :center.freeze

        # Hold the type of alignment
        #
        # @api private
        attr_reader :type

        # Initialize an Alignment
        #
        # @return [self]
        #
        # @raise [TypeError]
        #   raise if the alignment is not supported type
        #
        # @api private
        def initialize(type=nil)
          @type = coerce_to((type || LEFT), Symbol, :to_sym)
          assert_valid_type
        end

        # Assert the type is valid
        #
        # @return [undefined]
        #
        # @raise [TypeError]
        #   raise if the alignment is not supported type
        #
        # @api private
        def assert_valid_type
          unless supported.include? type
            raise TypeError, "Alignment must be one of: #{supported.join(' ')}"
          end
        end

        # List supported alignment types
        #
        # @return [Array]
        #   valid alignments
        #
        # @api private
        def supported
          [LEFT, RIGHT, CENTER]
        end

        # Format field with a given alignment
        #
        # @param [Object] field
        #
        # @param [Integer] column_width
        #
        # @param [String] space
        #
        # @return [String] aligned
        #
        # @api public
        def format(field, column_width, space='')
          case type
          when :left
            "%-#{column_width}s#{space}" % field.to_s
          when :right
            "%#{column_width}s#{space}" % field.to_s
          when :center
            center_align field, column_width, space
          end
        end

      private

        # Center aligns field
        #
        # @param [Object] field
        #
        # @param [Integer] column_width
        #
        # @param [String] space
        #
        # @return [String] aligned
        #
        # @api private
        def center_align(field, column_width, space)
          chars = field.to_s.chars.to_a
          if column_width >= chars.size
            right = ((pad_length = column_width - chars.length).to_f / 2).ceil
            left = pad_length - right
            [' ' * left, field, ' ' * right, space].join
          else
            "#{field}#{space}"
          end
        end

      end # Alignment
    end # Operation
  end # Table
end # TTY
