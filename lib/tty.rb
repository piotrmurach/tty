# -*- encoding: utf-8 -*-

require 'tty/version'

require 'tty/support/utils'
require 'tty/support/delegatable'
require 'tty/support/conversion'
require 'tty/support/coercion'
require 'tty/support/equatable'

require 'tty/color'
require 'tty/terminal'
require 'tty/system'
require 'tty/table'
require 'tty/vector'

require 'tty/table/border'
require 'tty/table/border/unicode'

require 'tty/table/column_set'

require 'tty/table/operation'
require 'tty/table/operation/alignment_set'
require 'tty/table/operation/alignment'
require 'tty/table/operation/truncation'
require 'tty/table/operation/wrapped'

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
