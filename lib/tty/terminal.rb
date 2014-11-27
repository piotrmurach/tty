# encoding: utf-8

module TTY
  class Terminal
    # Return access to color terminal
    #
    # @return [TTY::Terminal::Color]
    #
    # @api public
    attr_reader :color

    # Output pager
    #
    # @return [TTY::Terminal::Pager]
    #
    # @api public
    attr_reader :pager

    # Initialize a Terminal
    #
    # @api public
    def initialize(options = {})
      @color = Pastel.new
      @echo  = TTY::Terminal::Echo.new
      @raw   = TTY::Terminal::Raw.new
      @pager = TTY::Terminal::Pager
      @home  = Home.new
    end

    # Switch echo on
    #
    # @api public
    def echo_on
      @echo.on
    end

    # Switch echo off
    #
    # @api public
    def echo_off
      @echo.off
    end

    # Echo given block
    #
    # @param [Boolean] is_on
    #
    # @api public
    def echo(is_on = true, &block)
      @echo.echo(is_on, &block)
    end

    # Switch raw mode on
    #
    # @api public
    def raw_on
      @raw.on
    end

    # Switch raw mode off
    #
    # @api public
    def raw_off
      @raw.off
    end

    # Use raw mode in the given block
    #
    # @param [Boolean] is_on
    #
    # @api public
    def raw(is_on = true, &block)
      @raw.raw(is_on, &block)
    end

    # Find user home directory
    #
    # @return [String]
    #
    # @api public
    def home
      @home.home
    end

    # Run text through a dynamically chosen pager
    #
    # @param [String] text
    #   the text to page
    #
    # @api public
    def page(text)
      @pager.page(text)
    end
  end # Terminal
end # TTY
