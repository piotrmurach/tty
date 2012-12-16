# -*- encoding: utf-8 -*-

module TTY
  class Terminal

    @@default_width  = 80

    @@default_height = 24

    # @api public
    attr_reader :color

    def initialize
      @color = TTY::Terminal::Color.new(self.color?)
    end

    # Return default width of terminal
    #
    # @example
    #   default_width = TTY::Terminal.default_width
    #
    # @return [Integer]
    #
    # @api public
    def default_width
      @@default_width
    end

    # Set default width of terminal
    #
    # @param [Integer] width
    #
    # @return [Integer]
    #
    # @api public
    def default_width=(width)
      @@default_width = width
    end

    # Return default height of terminal
    #
    # @example
    #   default_height = TTY::Terminal.default_height
    #
    # @return [Integer]
    #
    # @api public
    def default_height
      @@default_height
    end

    # Set default height of terminal
    #
    # @example
    #   default_height = TTY::Terminal.default_height
    #
    # @return [Integer]
    #
    # @api public
    def default_height=(height)
      @@default_height = height
    end

    # Determine current width
    #
    # @return [Integer] width
    #
    # @api width
    def width
      if ENV['TTY_COLUMNS'] =~ /^\d+$/
        result = ENV['TTY_COLUMNS'].to_i
      else
        result = TTY::System.unix? ? dynamic_width : default_width
      end
    rescue
      default_width
    end

    # Determine current height
    #
    # @api public
    def height
      if ENV['TTY_LINES'] =~ /^\d+$/
        result = ENV['TTY_LINES'].to_i
      else
        result = TTY::System.unix? ? dynamic_height : self.default_height
      end
    rescue
      self.default_height
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
      %x{stty size 2>/dev/null}.split[1].to_i
    end

    # Detect terminal height with stty utility
    #
    # @return [Integer] height
    #
    # @api public
    def dynamic_height_stty
      %x{stty size 2>/dev/null}.split[0].to_i
    end

    # Detect terminal width with tput utility
    #
    # @return [Integer] width
    #
    # @api public
    def dynamic_width_tput
      %x{tput cols 2>/dev/null}.to_i
    end

    # Detect terminal height with tput utility
    #
    # @return [Integer] height
    #
    # @api public
    def dynamic_height_tput
      %x{tput lines 2>/dev/null}.to_i
    end

    # Check if terminal supports color
    #
    # @return [Boolean]
    #
    # @api public
    def color?
      %x{tput colors 2>/dev/null}.to_i > 2
    end

  end # Terminal
end # TTY
