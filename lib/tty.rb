# encoding: utf-8

require 'equatable'
require 'pastel'
require 'tty-color'
require 'tty-cursor'
require 'tty-command'
require 'tty-editor'
#require 'tty-file'
require 'tty-pager'
require 'tty-platform'
require 'tty-progressbar'
require 'tty-prompt'
require 'tty-screen'
require 'tty-spinner'
#require 'tty-table'
require 'tty-which'

require 'tty/version'
require 'tty/plugins'
require 'tty/plugins/plugin'

module TTY
  # An empty array used as a default value
  EMPTY_ARRAY = Array.new.freeze

  class << self
    def included(base)
      base.send :extend, ClassMethods
    end
  end

  module ClassMethods
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
