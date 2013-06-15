# -*- encoding: utf-8 -*-

module TTY

  # A class responsible for plugin loading
  class Plugin

    attr_reader :name

    attr_reader :gem

    attr_reader :gem_name

    attr_accessor :enabled

    # Initialize a Plugin
    #
    # @param [String] name
    #   the plugin name
    #
    # @param [Gem::Specification] gem
    #   the rubygems gem
    #
    # @api public
    def initialize(name, gem)
      @name     = name
      @gem      = gem
      @gem_name = "tty-#{name}"
      @enabled  = false
    end

    # Check if this plugin has been enabled
    #
    # @return [Boolean]
    #
    # @api public
    def enabled?
      !!enabled
    end

    # Load the plugin (require the gem)
    #
    # @api public
    def load!
      begin
        require gem_name unless enabled?
      rescue LoadError => error
        TTY.shell.error("Unable to load plugin #{gem_name}.")
      rescue => error
        TTY.shell.error("require '#{gem_name}' failed with #{error}")
      end
      self.enabled = true
    end

  end # Plugin
end # TTY
