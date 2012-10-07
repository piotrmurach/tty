# -*- encoding: utf-8 -*-

module TTY
  class Table

    # Raised when inserting into table with a mismatching row(s)
    class DimensionMismatchError < ArgumentError; end

  end # Table
end # TTY
