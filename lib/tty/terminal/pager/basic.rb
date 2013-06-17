# -*- encoding: utf-8 -*-

module TTY
  class Terminal

    # A class responsible for paging text
    class BasicPager < Pager

      PROMPT_HEIGHT = 3

      PAGE_BREAK = "--- Press enter/return to continue (or q to quit) ---"

      # Use ruby to page output text
      #
      # @api public
      def page
        text_lines = text.lines.to_a

        text_lines.each_slice(page_size) do |chunk|
          TTY.shell.say chunk.join
          break if chunk.size < page_size
          break if !continue?(text_lines)
        end
      end

      private

      # Check whether to progress with paging
      #
      # @param [Array[String]] text_lines
      #
      # @return [Boolean]
      #
      # @api private
      def continue?(text_lines)
        if text_lines.size > page_size
          question = TTY.shell.ask "\n#{PAGE_BREAK}"
          return false if question.read_string[/q/i]
        end
        return true
      end

      # Determine current page size
      #
      # @api private
      def page_size
        @page_size ||= TTY.terminal.height - PROMPT_HEIGHT
      end

    end # BasicPager
  end # Terminal
end # TTY
