# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Renderer

      # Renders table without any border styles.
      class Basic
        extend TTY::Delegatable

        attr_reader :padding

        attr_reader :indent

        # Table to be rendered
        #
        # @return [TTY::Table]
        #
        # @api public
        attr_reader :table


        # Table border to be rendered
        #
        # @return [TTY::Table::Border]
        #
        # @api private
        attr_reader :border_class

        TABLE_DELEGATED_METHODS = [:column_widths, :alignments]

        delegatable_method :table, *TABLE_DELEGATED_METHODS

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
        def self.render(table, options={})
          new(options).render(table)
        end

        # Renders table
        #
        # @param [TTY::Table] table
        #   the table to be rendered
        #
        # @return [String] string representation of table
        #
        # @api public
        def render(table, border_class=Border::Null)
          @table = table
          @border_class = border_class

          return if table.to_a.empty?
          # setup(options)
          body = []
          unless table.length.zero?
            ColumnSet.new(table).extract_widths!
            # TODO: throw an error if too many columns as compared to terminal width
            # and then change table.orientation from vertical to horizontal
            # TODO: Decide about table orientation

            body += render_header
            body += render_rows
          end
          body.compact.join("\n")
        end

        private

        # Format the header
        #
        # @return [Array[String]]
        #
        # @api private
        def render_header
          header = table.header
          if header
            aligned = alignments.align_header header,
                                              :column_widths => column_widths
            border = border_class.new(aligned)
            [border.top_line, border.row_line].compact
          else
            []
          end
        end

        # Format the rows
        #
        # @return [Arrays[String]]
        #
        # @api private
        def render_rows
          aligned = alignments.align_rows table.to_a,
                                          :column_widths => column_widths

          first_row_border = border_class.new(aligned.first)
          aligned_border   = aligned.map { |row| border_class.new(row).row_line }

          [ table.header ? first_row_border.separator : first_row_border.top_line,
            aligned_border,
            first_row_border.bottom_line ].compact
        end

      end # Basic
    end # Renderer
  end # Table
end # TTY
