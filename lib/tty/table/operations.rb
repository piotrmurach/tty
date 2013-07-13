# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class holding table field operations
    class Operations

      # The table
      #
      # @api private
      attr_reader :table
      private :table

      # Initialize Operations
      #
      # @param [TTY::Table] table
      #   the table to perform operations on
      #
      # @return [Object]
      #
      # @api public
      def initialize(table)
        @table = table
      end

      # Available operations
      #
      # @return [Hash]
      #
      # @api public
      def operations
        @operations ||= Hash.new { |hash, key| hash[key] = [] }
      end

      # Add operation
      #
      # @param [Symbol] type
      #   the operation type
      # @param [Object] object
      #   the callable object
      #
      # @return [Hash]
      #
      # @api public
      def add_operation(type, object)
        operations[type] << object
      end

      # Apply operations to a table row
      #
      # @param [Array[Symbol]] types
      #  the operation types
      # @param [Hash] options
      #   the options for the row
      #
      # @return [TTY::Table]
      #
      # @api public
      def run_operations(*args)
        options = Utils.extract_options!(args)
        types = args
        table.each_with_index do |val, row, col|
          types.each do |type|
            operations[type].each { |op| op.call(val, row, col, options)}
          end
        end
      end

    end # Operations
  end # Table
end # TTY
