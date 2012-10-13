# -*- encoding: utf-8 -*-

require 'tty/version'

require 'tty/support/utils'
require 'tty/support/delegatable'
require 'tty/support/conversion'
require 'tty/support/coercion'

require 'tty/color'
require 'tty/terminal'
require 'tty/system'
require 'tty/table'

require 'tty/table/operation/alignment_set'
require 'tty/table/operation/alignment'

module TTY

  # Raised when the argument type is different from expected
  class TypeError < ArgumentError; end

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
