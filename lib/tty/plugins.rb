# frozen_string_literal: true

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

    # Loads gemspec from a file and registers gems matching pattern.
    #
    # @param [String|Pathname] gemspec_path
    #   the path to gemspec
    # @param [Regex] pattern
    #   the pattern to match gems by
    #
    # @example
    #   plugins.load_from('foo.gemspec', /tty-(.*)/)
    #
    # @api public
    def load_from(gemspec_path, pattern)
      Gem.refresh
      spec = Gem::Specification.load(gemspec_path)
      dependencies = spec.runtime_dependencies.concat(spec.development_dependencies)
      dependencies.each do |gem|
        gem_name = gem.name[pattern]
        next if gem_name.to_s.empty?
        register(gem_name, Plugin.new(gem_name, gem))
      end
      self
    end

    # Activate all registered plugins that are not already enabled and
    # add lib paths to $LOAD_PATH.
    #
    # @api public
    def activate
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
