# -*- encoding: utf-8 -*-

require 'tty/version'

require 'tty/support/utils'
require 'tty/support/delegatable'
require 'tty/support/conversion'

require 'tty/color'
require 'tty/terminal'
require 'tty/system'
require 'tty/table'

module TTY

  class << self

    # Return terminal instance
    #
    # @return [TTY::Terminal]
    #
    # @api public
    def terminal
      @terminal ||= Terminal.new
    end

  end

end # TTY
