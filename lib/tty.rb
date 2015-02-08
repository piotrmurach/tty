# encoding: utf-8

require 'equatable'
require 'pastel'
require 'necromancer'
require 'tty-screen'
require 'tty-spinner'
require 'tty-progressbar'

require 'tty/version'

require 'tty/support/utils'
require 'tty/support/delegatable'
require 'tty/support/coercion'
require 'tty/support/unicode'

require 'tty/terminal'
require 'tty/system'
require 'tty/table'
require 'tty/text'
require 'tty/vector'
require 'tty/shell'
require 'tty/logger'
require 'tty/plugins'

require 'tty/plugins/plugin'

require 'tty/shell/response_delegation'
require 'tty/shell/question'
require 'tty/shell/question/validation'
require 'tty/shell/question/modifier'
require 'tty/shell/statement'
require 'tty/shell/suggestion'
require 'tty/shell/reader'
require 'tty/shell/response'

require 'tty/terminal/echo'
require 'tty/terminal/raw'
require 'tty/terminal/home'
require 'tty/terminal/pager'
require 'tty/terminal/pager/basic'
require 'tty/terminal/pager/system'

require 'tty/system/which'
require 'tty/system/editor'

require 'tty/text/distance'

require 'tty/table/header'
require 'tty/table/row'
require 'tty/table/field'

require 'tty/table/border'
require 'tty/table/border_dsl'
require 'tty/table/border_options'
require 'tty/table/border/unicode'
require 'tty/table/border/ascii'
require 'tty/table/border/null'
require 'tty/table/border/row_line'

require 'tty/table/column_set'
require 'tty/table/columns'
require 'tty/table/orientation'
require 'tty/table/orientation/horizontal'
require 'tty/table/orientation/vertical'
require 'tty/table/transformation'
require 'tty/table/indentation'
require 'tty/table/padder'

require 'tty/table/operations'
require 'tty/table/operation/alignment_set'
require 'tty/table/operation/truncation'
require 'tty/table/operation/wrapped'
require 'tty/table/operation/filter'
require 'tty/table/operation/escape'
require 'tty/table/operation/padding'

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

  # Raised when the passed in validation argument is of wrong type
  class ValidationCoercion < TypeError; end

  # Raised when the attribute is unknown
  class UnknownAttributeError < IndexError; end

  # Raised when command cannot be invoked
  class CommandInvocationError < StandardError; end

  # An empty array used as a default value
  EMPTY_ARRAY = Array.new.freeze

  class << self
    def included(base)
      base.send :extend, ClassMethods
    end
  end

  module ClassMethods
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

    # Return shared system object
    #
    # @return [TTY::System]
    #
    # @api public
    def system
      System
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

  extend ClassMethods
end # TTY
