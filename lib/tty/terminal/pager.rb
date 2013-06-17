# -*- encoding: utf-8 -*-

module TTY
  class Terminal

    # A class responsible for paging text inside terminal
    class Pager

      attr_accessor :enabled

      attr_reader :text

      # Initialize a Pager
      #
      # @param [String] text
      #   the text to page
      #
      # @api public
      def initialize(text=nil)
        @text = text
        @enabled = true
      end

      # Check if pager is enabled
      #
      # @return [Boolean]
      #
      # @api public
      def enabled?
        !!@enabled
      end

      # List possible executables for output paging
      #
      # @api private
      def self.executables
        [ ENV['GIT_PAGER'], `git config --get-all core.pager`.split.first,
          ENV['PAGER'], 'less -isr', 'more', 'cat', 'pager' ]
      end

      # Find first available system command for paging
      #
      # @api private
      def self.available
        self.executables.compact.uniq.find { |cmd| System.exists?(cmd) }
      end

      # Check if paging command exists
      #
      # @api private
      def self.available?
        !!available
      end

      # Command to execute pager
      #
      # @api private
      def self.command
        @command ||= available
      end

      # Pages output using configured pager
      #
      # @param [String] text
      #   the text to page
      #
      # @api public
      def self.page(text)
        return unless TTY.shell.tty?

        if System.unix? && available?
          SystemPager.new(text).page
        else
          BasicPager.new(text).page
        end
      end

    end # Pager
  end # Terminal
end # TTY
