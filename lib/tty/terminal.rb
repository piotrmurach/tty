# encoding: utf-8

module TTY
  class Terminal
    # Initialize a Terminal
    #
    # @api public
    def initialize(options = {})
      @home = Home.new
    end

    # Find user home directory
    #
    # @return [String]
    #
    # @api public
    def home
      @home.find_home
    end
  end # Terminal
end # TTY
