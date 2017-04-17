# encoding: utf-8

require_relative 'plugins/plugin'

module TTY
  # A class responsible for managing plugins installation
  class Plugins
    include Enumerable

    attr_reader :plugins

    # Initialize the Plugins
    #
    # @api public
    def initialize
      @plugins = []
    end

    # Iterate over plugins
    # @example
    #   plugins.each { |plug| ... }
    #
    # @return [self]
    #
    # @api public
    def each(&block)
      return to_enum unless block_given?
      to_ary.each(&block)
      self
    end

    # Register plugin with name in internal array
    #
    # @param [String] name
    #
    # @param [TTY::Plugin] plugin
    #
    # @api public
    def register(name, plugin = false)
      return unless plugin && !loaded?(name)
      @plugins << plugin
    end

    # Find all installed TTY plugins and store them
    #
    # @param [String] :lib_name
    #
    # @return [self]
    #
    # @api private
    def find(lib_name = 'tty', options = {})
      included = options.fetch(:include, [])
      Gem.refresh
      spec = Gem::Specification.find_by_name(lib_name)
      spec.runtime_dependencies.each do |gem|
        plugin_name = gem.name[/^#{lib_name}-(.*)/]
        if included.include?(gem.name)
          plugin_name = included.grep(/#{gem.name}/)[0]
        end
        next if plugin_name.to_s.empty?
        register(plugin_name, Plugin.new(plugin_name, gem))
      end
      self
    end

    # Load all plugins that are not enabled
    #
    # @api public
    def load
      plugins.each do |plugin|
        plugin.load! unless plugin.enabled?
      end
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

    # Check if plugin is already loaded
    #
    # @api private
    def loaded?(name)
      plugins.any? { |plugin| plugin.name == name }
    end

    def to_ary
      @plugins.dup
    end

    def to_a
      to_ary
    end

    def size
      to_ary.size
    end
    alias length size
  end # PluginManager
end # TTY
