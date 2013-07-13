# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      # A class responsible for transforming table field
      class Filter

        # Initialize a Filter
        #
        # @api public
        def initialize(filter)
          @filter = filter
        end

        # Apply filer to the provided table field
        #
        # @param [TTY::Table::Field] field
        #
        # @param [Integer] row
        #   the field row index
        #
        # @param [Integer] col
        #   the field column index
        #
        # @api public
        def call(field, row, col, options={})
          field.value = @filter.call(field.value, row, col)
        end

      end # Filter

    end # Operation
  end # Table
end # TTY
