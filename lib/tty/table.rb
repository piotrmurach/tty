# -*- encoding: utf-8 -*-

require 'forwardable'
require 'tty/table/renderer'
require 'tty/table/error'
require 'tty/table/validatable'

module TTY
  class Table
    include Comparable, Enumerable, Renderer, Conversion
    include Validatable
    extend Forwardable

    # The table header
    #
    # @return [Enumerable]
    #
    # @api public
    attr_reader :header

    # The table rows
    #
    # @return [Enumerable]
    #
    # @api private
    attr_reader :rows
    private :rows

    # The table enforced column widths
    #
    # @return [Array]
    #
    # @api public
    attr_accessor :column_widths

    # The table column alignments
    #
    # @return [Operation::AlignmentSet]
    #
    # @api private
    attr_reader :alignments

    # Subset of safe methods that both Array and Hash implement
    def_delegators(:@rows, :[], :assoc, :flatten, :include?, :index,
      :inspect, :length, :select, :to_a, :values_at, :pretty_print, :rassoc)

    # The table orientation
    #
    def direction
      # TODO implement table orientation
    end

    # Create a new Table where each argument is a row
    #
    # @example
    #   table = TTY::Table.new[['a1', 'a2'], ['b1', 'b2']]
    #
    # @api public
    def self.[](*rows)
      self.new(:rows => rows)
    end

    # Instantiate a new Table
    #
    # @example of no header
    #   rows  = [ ['a1', 'a2'], ['b1', 'b2'] ]
    #   table = Table.new rows
    #
    # @example of direct parameters
    #   rows  = [ ['a1', 'a2'], ['b1', 'b2'] ]
    #   table = Table.new ['Header 1', 'Header 2'], rows
    #
    # @example of parameters passed as options
    #   rows  = [ ['a1', 'a2'], ['b1', 'b2'] ]
    #   table = Table.new :header => ['Header 1', 'Header 2'], :rows => rows
    #
    # @param [Array[Symbol], Hash] *args
    #
    # @api public
    def self.new(*args, &block)
      options = Utils.extract_options!(args)
      if args.size.nonzero?
        rows = args.pop
        header = args.size.zero? ? nil : args.first
        super({:header => header, :rows => rows}.merge(options), &block)
      else
        super(options, &block)
      end
    end

    # Initialize a Table
    #
    # @param [Hash] options
    #   the options to create the table with
    # @option options [String] :header
    #   column names to be displayed
    # @option options [String] :rows
    #   Array of Arrays expressing the rows
    # @option options [String] :renderer
    #   used to format table output
    # @option options [String] :column_aligns
    #   used to format table individual column alignment
    # @option options [String] :column_widths
    #   used to format table individula column width
    #
    # @return [TTY::Table]
    #
    # @api private
    def initialize(options={}, &block)
      @header        = options.fetch :header, []
      @rows          = coerce(options.fetch :rows, [])
      @renderer      = pick_renderer options[:renderer]
      # TODO: assert that row_size is the same as column widths & aligns
      @column_widths = options.fetch :column_widths, []
      @alignments    = Operation::AlignmentSet.new options[:column_aligns]

      assert_row_sizes @rows
      yield_or_eval &block if block_given?
    end

    # Lookup element of the table given a row(i) and column(j)
    #
    # @api public
    def [](i, j)
      if i >= 0 && j >= 0
        rows.fetch(i){return nil}[j]
      else
        raise IndexError.new("element at(#{i},#{j}) not found")
      end
    end
    alias at        []
    alias element   []
    alias component []

    # Set table value at row(i) and column(j)
    #
    # @api private
    def []=(i, j, val)
      @rows[i][j] = val
    end
    private :[]=

    # Return a row number at the index of the table as an Array.
    # When a block is given, the elements of that Array are iterated over.
    #
    # @example
    #   rows  = [ ['a1', 'a2'], ['b1', 'b2'] ]
    #   table = TTY::Table.new :rows => rows
    #   table.row(1) { |element| ... }
    #
    # @param [Integer] index
    #
    # @yield []
    #   optional block to execute in the iteration operation
    #
    # @return [self]
    #
    # @api public
    def row(index, &block)
      if block_given?
        rows.fetch(index){return self}.each(&block)
        self
      else
        rows.fetch(index){return nil}
      end
    end

    # Return a column number at the index of the table as an Array.
    # When a block is given, the elements of that Array are iterated over.
    #
    # @example
    #   rows  = [ ['a1', 'a2'], ['b1', 'b2'] ]
    #   table = TTY::Table.new :rows => rows
    #   table.column(1) { |element| ... }
    #
    # @param [Integer] index
    #
    # @yield []
    #   optional block to execute in the iteration operation
    #
    # @return [self]
    #
    # @api public
    def column(index)
      if block_given?
        return self if index >= column_size || index < 0
        rows.map { |row| yield row[index].compact }
      else
        return nil if index >= column_size || index < 0
        rows.map { |row| row[index] }.compact
      end
    end

    # Add row to table
    #
    # @param [Array] row
    #
    # @api public
    def <<(row)
      rows_copy = rows.dup
      assert_row_sizes rows_copy << row
      rows << row
    end

    # Iterate over each tuple in the set
    #
    # @example
    #   table = TTY::Table.new(header, tuples)
    #   table.each { |row| ... }
    #
    # @yield [Array[Array]]
    #
    # @return [self]
    #
    # @api public
    def each
      return to_enum unless block_given?
      rows.each do |row|
        yield row
      end
      self
    end

    # Return the number of columns
    #
    # @example
    #   table.column_size # => 5
    #
    # @return [Integer]
    #
    # @api public
    def column_size
      return rows[0].size if (rows.size > 0)
      return 0
    end

    # Return the number of rows
    #
    # @example
    #   table.row_size # => 5
    #
    # @return [Integer]
    #
    # @api public
    def row_size
      rows.size
    end

    # Return the number of rows and columns
    #
    # @example
    #   table.size # => [3,5]
    #
    # @return [Array] row x columns
    #
    # @api public
    def size
      [row_size, column_size]
    end

    # Check table width
    #
    # @return [Integer] width
    #
    # @api public
    def width
      render(self)
      total_width
    end

    # Return true if this is an empty table, i.e. if the number of
    # rows or the number of columns is 0
    #
    # @return [Boolean]
    #
    # @api public
    def empty?
      column_size == 0 || row_size == 0
    end

    # Compare this table with other table for equality
    #
    # @param [TTY::Table] other
    #
    # @return [Boolean]
    #
    # @api public
    def eql?(other)
      instance_of?(other.class)
    end

    # Compare the table with other table for equivalency
    #
    # @example
    #   table == other # => true or false
    #
    # @param [TTY::Table] other
    #   the other table to compare with
    #
    # @return [Boolean]
    def ==(other)
      header == other.header &&
      to_a == other.to_a
    end

    # Return string representation of table
    #
    # @return [String]
    #
    # @api public
    def to_s
      render(self)
    end

    # Coerce an Enumerable into a Table
    # This coercion mechanism is used by Table to handle Enumerable types
    # and force them into array type.
    #
    # @param [Enumerable] object
    #    the object to coerce
    #
    # @return [Array]
    #
    # @api public
    def coerce(rows)
      convert_to_array(rows)
    end

  private

    # Evaluate block
    #
    # @return [Table]
    #
    # @api private
    def yield_or_eval(&block)
      return unless block
      block.arity > 0 ? yield(self) : self.instance_eval(&block)
    end

  end # Table
end # TTY
