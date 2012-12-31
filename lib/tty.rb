# -*- encoding: utf-8 -*-

require 'tty/version'

require 'tty/support/utils'
require 'tty/support/delegatable'
require 'tty/support/conversion'
require 'tty/support/coercion'
require 'tty/support/equatable'
require 'tty/support/unicode'

require 'tty/terminal'
require 'tty/system'
require 'tty/table'
require 'tty/text'
require 'tty/vector'
require 'tty/shell'

require 'tty/shell/question'
require 'tty/shell/question/validation'
require 'tty/shell/question/modifier'
require 'tty/shell/statement'
require 'tty/shell/reader'
require 'tty/shell/response'
require 'tty/shell/response/boolean'

require 'tty/terminal/color'
require 'tty/terminal/echo'

require 'tty/text/wrapping'
require 'tty/text/truncation'

require 'tty/table/border'
require 'tty/table/border/unicode'
require 'tty/table/border/ascii'
require 'tty/table/border/null'

require 'tty/table/column_set'

require 'tty/table/operation/alignment_set'
require 'tty/table/operation/alignment'
require 'tty/table/operation/truncation'
require 'tty/table/operation/wrapped'

module TTY

  # Raised when the argument type is different from expected
  class TypeError < ArgumentError; end

  # Raised when the required argument is not supplied
  class ArgumentRequired < ArgumentError; end

  # Raised when the argument validation fails
  class ArgumentValidation < ArgumentError; end

  # Raised when the argument is not expected
  class InvalidArgument < ArgumentError; end

  # Raised when the passed in validation argument is of wrong type
  class ValidationCoercion < TypeError; end

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
