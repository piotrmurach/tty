# encoding: utf-8

module TTY
  class Table
    # Raised when inserting into table with a mismatching row(s)
    class DimensionMismatchError < ArgumentError; end

    # Raised when reading non-existent element from a table
    class TupleMissing < IndexError
      attr_reader :i, :j

      def initialize(i, j)
        @i, @j = i, j
        super("element at(#{i},#{j}) not found")
      end
    end
  end # Table
end # TTY
