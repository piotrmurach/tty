# -*- encoding: utf-8 -*-

require 'forwardable'
require 'tty/table/renderer'

module TTY
  class Table
    include Comparable, Enumerable, Renderer
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

    # Subset of safe methods that both Array and Hash implement
    def_delegators(:@rows, :[], :assoc, :empty?, :flatten,
      :include?, :index, :inspect, :length, :select, :to_a, :values_at,
      :pretty_print, :rassoc)

    # The table orientation
    #
    def direction
      # TODO implement table orientation
    end

    # Instantiate a new Table
    #
    # @example of direct parameters
    #   rows  = [ ['a1', 'a2'], ['b1', 'b2'] ]
    #   table = Table.new ['Header 1', 'Header 2'], rows
    #
    # @example of parameters passed as options
    #   rows  = [ ['a1', 'a2'], ['b1', 'b2'] ]
    #   table = Table.new :header => ['Header 1', 'Header 2'], :rows => rows
    #
    # @api public
    def self.new(*args, &block)
      options = Utils.extract_options!(args)
      if args.first.is_a? Array
        rows = args.size == 2 ? args.pop : []
        super({:header => args.first, :rows => rows}.merge(options), &block)
      else
        super(options, &block)
      end
    end

    # Initialize a Table
    #
    # @param [Hash] options
    # @return [Table]
    #
    # @api private
    def initialize(options={}, &block)
      @header   = options.fetch :header, []
      @rows     = options.fetch :rows, []
      @renderer = pick_renderer options[:renderer]
      yield_or_eval &block if block_given?
    end

    # Lookup element of the table given a row(i) and column(j)
    #
    # @api public
    def [](i, j)
      if i >= 0 && j >= 0
        rows.fetch(i){return nil}[j]
      else
        raise IndexError.new("index #{index} not found")
      end
    end
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
      rows << row
    end

    # Iterate over each tuple in the set
    #
    # @example
    #   table = TTY::Table.new(header, tuples)
    #   table.each { |tuple| ... }
    #
    # @yield [tuple]
    #
    # @return [self]
    # @api public
    def each
      return to_enum unless block_given?
      rows.each do |row|
        yield row
      end
      self
    end

    # Return the number of rows
    #
    # @example
    #   table.size # => 5
    #
    # @return [Integer]
    def size
      return rows[0].length if (rows.length > 0)
      return 0
    end

    # Check table width
    #
    # @return [Integer] width
    def width
      extract_column_widths(rows)
      total_width
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
    # @api public
    def to_s
      render(rows)
    end

    # Coerce an Enumerable into a Table
    #
    # @param [Enumerable] object
    #    the object to coerce
    #
    def self.coerce(object)
      if object.kind_of?(TTY::Table)
        object
      elsif object.kind_of?(Hash)
        array = [object.keys]
        array << object.values
      end
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
