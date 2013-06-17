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
require 'tty/coercer'
require 'tty/logger'
require 'tty/plugins'

require 'tty/plugins/plugin'

require 'tty/coercer/range'
require 'tty/coercer/integer'
require 'tty/coercer/float'
require 'tty/coercer/boolean'

require 'tty/shell/response_delegation'
require 'tty/shell/question'
require 'tty/shell/question/validation'
require 'tty/shell/question/modifier'
require 'tty/shell/statement'
require 'tty/shell/suggestion'
require 'tty/shell/reader'
require 'tty/shell/response'

require 'tty/terminal/color'
require 'tty/terminal/echo'
require 'tty/terminal/home'
require 'tty/terminal/pager/basic'
require 'tty/terminal/pager/system'

require 'tty/system/which'

require 'tty/text/distance'
require 'tty/text/truncation'
require 'tty/text/wrapping'

require 'tty/table/header'
require 'tty/table/row'
require 'tty/table/field'

require 'tty/table/border'
require 'tty/table/border_dsl'
require 'tty/table/border_options'
require 'tty/table/border/unicode'
require 'tty/table/border/ascii'
require 'tty/table/border/null'

require 'tty/table/column_set'
require 'tty/table/orientation'
require 'tty/table/orientation/horizontal'
require 'tty/table/orientation/vertical'

require 'tty/table/operations'
require 'tty/table/operation/alignment_set'
require 'tty/table/operation/alignment'
require 'tty/table/operation/truncation'
require 'tty/table/operation/wrapped'

module TTY

  # Raised when the argument type is different from expected
  class TypeError < ArgumentError; end

  # Raised when the operation is not implemented
  class NoImplementationError < NotImplementedError; end

  # Raised when the required argument is not supplied
  class ArgumentRequired < ArgumentError; end

  # Raised when the argument validation fails
  class ArgumentValidation < ArgumentError; end

  # Raised when the argument is not expected
  class InvalidArgument < ArgumentError; end

  # Raised when the table orientation is unkown
  class InvalidOrientationError < ArgumentError; end

  # Raised when the passed in validation argument is of wrong type
  class ValidationCoercion < TypeError; end

  # Raised when the attribute is unknown
  class UnknownAttributeError < IndexError; end


  # An empty array used as a default value
  EMPTY_ARRAY = Array.new.freeze

  class << self

    # Return shared terminal instance
    #
    # @return [TTY::Terminal]
    #
    # @api public
    def terminal
      @terminal ||= Terminal.new
    end

    # Return shared shell instance
    #
    # @return [TTY::Shell]
    #
    # @api public
    def shell(input=$stdin, output=$stdout)
      @shell ||= Shell.new(input, output)
    end

    # Return shared plugins instance
    #
    # @return [TTY::Plugins]
    #
    # @api public
    def plugins
      @plugins ||= Plugins.new
    end
  end

end # TTY
