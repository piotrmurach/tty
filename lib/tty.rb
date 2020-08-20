# frozen_string_literal: true

require_relative "tty/cli"
require_relative "tty/plugins"
require_relative "tty/version"

module TTY
  GEMSPEC_PATH = ::File.expand_path("#{::File.dirname(__FILE__)}/../tty.gemspec")

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

TTY.plugins.load_from(TTY::GEMSPEC_PATH, /tty-(.*)|pastel/)
TTY.plugins.activate
