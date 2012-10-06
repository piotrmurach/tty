# -*- encoding: utf-8 -*-

module TTY
  class Table

    # @api public
    def self.renderer
      @renderer ||= if TTY::Color.color?
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

      autoload :Basic,   'tty/table/renderer/basic'
      autoload :Color,   'tty/table/renderer/color'
      autoload :Unicode, 'tty/table/renderer/unicode'

      RENDERER_DELEGATED_METHODS = [ :render, :extract_column_widths, :total_width]

      RENDERER_MAPPER = {
        :basic   => TTY::Table::Renderer::Basic,
        :color   => TTY::Table::Renderer::Color,
        :unicode => TTY::Table::Renderer::Unicode
      }

      # Initialize a Renderer
      #
      # @api private
      def initialize(options={})
        super
        self.renderer = RENDERER_MAPPER[:"#{options[:renderer]}"].new
      end

      def pick_renderer(renderer)
      if renderer
        RENDERER_MAPPER[renderer].new
      else
        self.renderer
      end
      end

      # Return the default renderer
      #
      # @return [TTY::Table::Renderer]
      #
      # @api public
      def renderer
        @renderer ||= TTY::Table.renderer.new
      end

      def renderer=(renderer)
        @renderer = renderer
      end

      delegatable_method :renderer, *RENDERER_DELEGATED_METHODS

    end # Renderer

  end # Table
end # TTY
