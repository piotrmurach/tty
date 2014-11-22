# encoding: utf-8

module TTY
  class Terminal
    # Return default width of terminal
    #
    # @example
    #   default_width = TTY::Terminal.default_width
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :default_width

    # Return default height of terminal
    #
    # @example
    #   default_height = TTY::Terminal.default_height
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :default_height

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
      @pager = TTY::Terminal::Pager
      @home  = Home.new
      @default_width  = options.fetch(:default_width) { 80 }
      @default_height = options.fetch(:default_height) { 24 }
    end

    # Determine current width
    #
    # @return [Integer] width
    #
    # @api width
    def width
      env_tty_columns = ENV['TTY_COLUMNS']
      if env_tty_columns =~ /^\d+$/
        env_tty_columns.to_i
      else
        TTY::System.unix? ? dynamic_width : default_width
      end
    rescue
      default_width
    end

    # Determine current height
    #
    # @return [Integer] height
    #
    # @api public
    def height
      env_tty_lines = ENV['TTY_LINES']
      if env_tty_lines =~ /^\d+$/
        env_tty_lines.to_i
      else
        TTY::System.unix? ? dynamic_height : default_height
      end
    rescue
      default_height
    end

    # Calculate dynamic width of the terminal
    #
    # @return [Integer] width
    #
    # @api public
    def dynamic_width
      @dynamic_width ||= (dynamic_width_stty.nonzero? || dynamic_width_tput)
    end

    # Calculate dynamic height of the terminal
    #
    # @return [Integer] height
    #
    # @api public
    def dynamic_height
      @dynamic_height ||= (dynamic_height_stty.nonzero? || dynamic_height_tput)
    end

    # Detect terminal width with stty utility
    #
    # @return [Integer] width
    #
    # @api public
    def dynamic_width_stty
      %x(tty size 2>/dev/null).split[1].to_i
    end

    # Detect terminal height with stty utility
    #
    # @return [Integer] height
    #
    # @api public
    def dynamic_height_stty
      %x(tty size 2>/dev/null).split[0].to_i
    end

    # Detect terminal width with tput utility
    #
    # @return [Integer] width
    #
    # @api public
    def dynamic_width_tput
      %x(tput cols 2>/dev/null).to_i
    end

    # Detect terminal height with tput utility
    #
    # @return [Integer] height
    #
    # @api public
    def dynamic_height_tput
      %x(tput lines 2>/dev/null).to_i
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
