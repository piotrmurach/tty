# frozen_string_literal: true

module TTY
  # A class responsible for plugin loading
  class Plugin
    attr_reader :name

    attr_reader :gem

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
      @enabled  = false
    end

    # Check if this plugin has been enabled
    #
    # @return [Boolean]
    #
    # @api public
    def enabled?
      @enabled
    end

    # Load the plugin (require the gem)
    #
    # @api public
    def load!
      begin
        require name unless enabled?
      rescue LoadError => error
        puts("Unable to load plugin #{name} due to #{error}.")
      rescue => error
        puts("require '#{name}' failed with #{error}")
      end
      @enabled = true
    end
  end # Plugin
end # TTY
