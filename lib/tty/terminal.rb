# encoding: utf-8

module TTY
  class Terminal
    # Return access to color terminal
    #
    # @return [TTY::Terminal::Color]
    #
    # @api public
    attr_reader :color

    # Initialize a Terminal
    #
    # @api public
    def initialize(options = {})
      @color = Pastel.new
      @home  = Home.new
    end

    # Find user home directory
    #
    # @return [String]
    #
    # @api public
    def home
      @home.home
    end
  end # Terminal
end # TTY
