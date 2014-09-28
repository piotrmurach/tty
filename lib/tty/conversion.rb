# encoding: utf-8

module TTY
  module Conversion
    TypeError = Class.new(StandardError)

    # Raised when cannot conver to a given type
    NoTypeConversionAvailable = Class.new(StandardError)
  end
end

require 'tty/conversion/converter/array'
require 'tty/conversion/converter/boolean'
require 'tty/conversion/converter/float'
require 'tty/conversion/converter/integer'
require 'tty/conversion/converter/range'
