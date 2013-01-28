# -*- encoding: utf-8 -*-

module TTY
  class Table

    # Determine renderer based on terminal capabilities
    #
    # @return [TTY::Table::Renderer]
    #
    # @api public
    def self.renderer
      @renderer ||= if TTY.terminal.color?
        TTY::Table::Renderer::Color
      else
        TTY::Table::Renderer::Basic
      end
    end

    # @api public
    def self.renderer=(klass)
      @renderer = klass
    end

    # A mixin to allow common rendering methods
    #
    # @return [self]
    #
    # @api public
    module Renderer
      extend TTY::Delegatable

      autoload :ASCII,   'tty/table/renderer/ascii'
      autoload :Basic,   'tty/table/renderer/basic'
      autoload :Color,   'tty/table/renderer/color'
      autoload :Unicode, 'tty/table/renderer/unicode'

      RENDERER_DELEGATED_METHODS = [ :render, :total_width]

      RENDERER_MAPPER = {
        :ascii   => TTY::Table::Renderer::ASCII,
        :basic   => TTY::Table::Renderer::Basic,
        :color   => TTY::Table::Renderer::Color,
        :unicode => TTY::Table::Renderer::Unicode
      }

      # Initialize a Renderer
      #
      # @api private
      def initialize(options={})
        super()
      end

      # Determine renderer class based on string name
      #
      # @param [Symbol] renderer
      #   the renderer used for displaying table out of [:basic, :color, :unicode]
      #
      # @return [TTY::Table::Renderer]
      #
      # @api private
      def pick_renderer(type=nil)
        self.renderer= (type ? RENDERER_MAPPER[type].new : self.renderer)
      end

      # Return the default renderer
      #
      # @return [TTY::Table::Renderer]
      #
      # @api public
      def renderer
        @renderer ||= TTY::Table.renderer.new
      end

      # Set the renderer
      #
      # @return [TTY::Table::Renderer]
      #
      # @api private
      def renderer=(renderer)
        @renderer = renderer
      end

      # Add custom border for the renderer
      #
      # @api public
      def renders_with(klass)
        @border_class = klass
      end

      delegatable_method :renderer, *RENDERER_DELEGATED_METHODS

    end # Renderer

  end # Table
end # TTY
