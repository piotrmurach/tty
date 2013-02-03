# -*- encoding: utf-8 -*-

require 'forwardable'
require 'tty/table/renderer'
require 'tty/table/error'
require 'tty/table/validatable'

module TTY
  class Table
    include Comparable, Enumerable, Renderer, Conversion
    include Validatable, Equatable
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

    # The table border class
    #
    # @api private
    attr_reader :border_class

    # The table orientation out of :horizontal and :vertical
    #
    # @reutnr [TTY::Table::Orientation]
    #
    # @api public
    attr_reader :orientation

    # Subset of safe methods that both Array and Hash implement
    def_delegators(:@rows, :[], :assoc, :flatten, :include?, :index,
                   :length, :select, :to_a, :values_at, :pretty_print, :rassoc)

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
    # @example of parameters passed as hash
    #   Table.new [ {'Header1' => ['a1','a2'], 'Header2' => ['b1', 'b2'] }] }
    #
    # @param [Array[Symbol], Hash] *args
    #
    # @api public
    def self.new(*args, &block)
      options = Utils.extract_options!(args)
      if args.size.nonzero?
        super(extract_tuples(args).merge(options), &block)
      else
        super(options, &block)
      end
    end

    # Extract header and row tuples from arguments
    #
    # @param [Array] args
    #
    # @api private
    def self.extract_tuples(args)
      rows   = args.pop
      header = args.size.zero? ? nil : args.first
      if rows.first.is_a?(Hash)
        header = rows.map(&:keys).flatten.uniq
        rows   = rows.inject([]) { |arr, el| arr + el.values }
      end
      { :header => header, :rows => rows }
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
      validate_options! options

      @header        = options.fetch(:header) { nil }
      @rows          = coerce options.fetch(:rows) { [] }
      @renderer      = pick_renderer options[:renderer]
      @border        = TTY::Table::BorderOptions.from(options.delete(:border))
      @orientation   = Orientation.coerce options.fetch(:orientation) { :horizontal }
      # TODO: assert that row_size is the same as column widths & aligns
      @column_widths = Array(options.delete(:column_widths)).map(&:to_i)
      @alignments    = Operation::AlignmentSet.new Array(options.delete(:column_aligns)).map(&:to_sym)

      assert_row_sizes @rows
      @orientation.transform(self)
      yield_or_eval &block if block_given?
    end

    # Sets table orientation
    #
    # @param [String,Symbol] value
    #
    # @api public
    def orientation=(value)
      @orientation = Orientation.coerce value
    end

    # Marks this table as rotated
    #
    # @return [Boolean]
    #
    # @api public
    def rotated?
      @rotated
    end

    # Rotate the table between vertical and horizontal orientation
    #
    # @return [self]
    #
    # @api private
    def rotate
      orientation.transform(self)
      self
    end

    # Rotate the table vertically
    #
    # @api private
    def rotate_vertical
      @rows    = ([header].compact + rows).transpose
      @header  = [] if header
      @rotated = true
    end

    # Rotate the table horizontally
    #
    # @api private
    def rotate_horizontal
      transposed = rows.transpose
      if header && header.empty?
        @rows = transposed[1..-1]
        @header = transposed[0]
      elsif rotated?
        @rows = transposed
      end
    end

    # Store border characters, style and separator for the table rendering
    #
    # @param [Hash, BorderOptions] options
    #
    # @yield [] block representing border options
    #
    # @api public
    def border(options=(not_set=true), &block)
      @border = TTY::Table::BorderOptions.new unless @border
      if block_given?
        border_dsl = TTY::Table::BorderDSL.new(&block)
        @border = border_dsl.options
      elsif !not_set
        @border = TTY::Table::BorderOptions.from(options)
      end
      @border
    end

    # Lookup element of the table given a row(i) and column(j)
    #
    # @api public
    def [](i, j=false)
      return row(i) unless j
      if i >= 0 && j >= 0
        rows.fetch(i){return nil}[j]
      else
        raise TTY::Table::TupleMissing.new(i,j)
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
    # @return [self]
    #
    # @api public
    def <<(row)
      rows_copy = rows.dup
      assert_row_sizes rows_copy << row
      rows << row
      self
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
      ColumnSet.new(self).extract_widths!.total_width
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
