# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Renderer
      class Basic

        attr_reader :padding

        attr_reader :indent

        attr_reader :column_widths

        attr_reader :column_aligns

        # Return an array of table rows
        #
        # @return [Array[Array]]
        #
        # @api private
        attr_reader :rows
        private :rows

        # Return an AlignmentSet object for processing alignments
        #
        # @return [AlignmentSet]
        #
        # @api private
        attr_reader :alignment_set
        private :alignment_set

        # Initialize and setup a Renderer
        #
        # @param [Hash] options
        #   :indent - Indent the first column by indent value
        #   :padding - Pad out the row cell by padding value
        #   :col_widths - Enforce particular column width values
        #
        # @return [Table::Renderer::Basic]
        def initialize(options={})
          setup(options)
        end

        # Setup attributes when Renderer is invoked
        #
        # @return [self]
        #
        # @api private
        def setup(options = {})
          @padding    = 0
          @indent     = options.fetch :indent, 0
          # TODO: assert that row_size is the same as column widths & aligns
          @column_widths = options.fetch :column_widths, []
          @column_aligns = options.fetch :column_aligns, []
          @alignment_set = TTY::Table::Operation::AlignmentSet.new column_aligns
          self
        end
        private :setup

        # Sets the output padding,
        #
        # @param [Integer] value
        #   the amount of padding, not allowed to be zero
        #
        # @api public
        def padding=(value)
          @padding = [0, value].max
        end

        # @api public
        def self.render(rows, options={})
          new(options).render(rows)
        end

        # Renders table
        #
        # @param [Enumerable] rows
        #   the table rows
        #
        # @return [String] string representation of table
        #
        # @api public
        def render(rows, options={})
          return if rows.empty?
          setup(options)
          # TODO: Decide about table orientation
          @rows = rows
          body = []
          unless rows.length.zero?
            extract_column_widths(rows)
            body += render_rows
          end
          body.join("\n")
        end

        # Calcualte total table width
        #
        # @return [Integer]
        #
        # @api public
        def total_width
          column_widths.reduce(:+)
        end

        # Calcualte maximum column widths
        #
        # @return [Array] column widths
        #
        # @api private
        def extract_column_widths(rows)
          return column_widths unless column_widths.empty?
          # TODO: throw an error if too many columns as compared to terminal width
          colcount = rows.max{ |a,b| a.size <=> b.size }.size
          maximas = []
          start = 0

          start.upto(colcount - 1) do |index|
            maximum = rows.map { |row|
              row[index] ? (row[index].to_s.size) : 0
            }.max
            maximas << maximum
          end
          @column_widths = maximas
        end

        # Format the rows
        #
        # @return [Arrays[String]]
        #
        # @api private
        def render_rows
          alignment_set.align_rows rows, :column_widths => column_widths
        end

      end # Basic
    end # Renderer
  end # Table
end # TTY
