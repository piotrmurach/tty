# encoding: utf-8

module TTY
  # A class responsible for managing plugins installation
  class Plugins
    PLUGIN_PREFIX = 'tty'

    attr_accessor :plugins
    private :plugins

    # Initialize the Plugins
    #
    # @api public
    def initialize
      @plugins = []
    end

    # Load all plugins that are not enabled
    #
    # @api public
    def load
      plugins.each do |plugin|
        plugin.load! unless plugin.enabled?
      end
    end

    # Register plugin with name in internal array
    #
    # @param [String] name
    #
    # @param [TTY::Plugin] plugin
    #
    # @api public
    def register(name, plugin = false)
      if plugin && !loaded?(name)
        plugins << plugin
      end
    end

    # Find all installed TTY plugins and store them
    #
    # @api private
    def find
      Gem.refresh
      Gem::Specification.each do |gem|
        next unless gem.name =~ /^#{PLUGIN_PREFIX}/
        plugin_name = gem.name[/^#{PLUGIN_PREFIX}-(.*)/, 1]
        register(plugin_name, Plugin.new(plugin_name, gem))
      end
      plugins
    end

    # Return a list of all plugin names as strings
    #
    # @api public
    def names
      plugins.reduce({}) do |hash, plugin|
        hash[plugin.name] = plugin
        hash
      end
    end

    private

    # Check if plugin is already loaded
    #
    # @api private
    def loaded?(name)
      plugins.any? { |plugin| plugin.gem_name == name }
    end
  end # PluginManager
end # TTY
