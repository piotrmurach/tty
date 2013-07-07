# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class responsible for rendering tabular data
    class Renderer
      autoload :ASCII,   'tty/table/renderer/ascii'
      autoload :Basic,   'tty/table/renderer/basic'
      autoload :Color,   'tty/table/renderer/color'
      autoload :Unicode, 'tty/table/renderer/unicode'

      RENDERER_MAPPER = {
        :ascii   => TTY::Table::Renderer::ASCII,
        :basic   => TTY::Table::Renderer::Basic,
        :color   => TTY::Table::Renderer::Color,
        :unicode => TTY::Table::Renderer::Unicode
      }

      # Determine renderer class based on string name
      #
      # @param [Symbol] renderer
      #   the renderer used for displaying table out of [:basic, :color, :unicode]
      #
      # @return [TTY::Table::Renderer]
      #
      # @api private
      def self.pick_renderer(type=nil)
         (type ? RENDERER_MAPPER[type] : TTY::Table::Renderer::Basic)
      end

      # Add custom border for the renderer
      #
      # @param [TTY::Table::Border] border_class
      #
      # @param [TTY::Table] table
      #
      # @param [Hash] options
      #
      # @raise [TypeError]
      #   raised if the klass does not inherit from Table::Border
      #
      # @raise [NoImplemntationError]
      #   raise if the klass does not implement def_border
      #
      # @api public
      def self.render_with(border_class, table, options={})
        unless border_class <= TTY::Table::Border
          raise TypeError, "#{border_class} should inherit from TTY::Table::Border"
        end
        unless border_class.characters
          raise NoImplementationError, "#{border_class} should implement def_border"
        end
        options[:border_class] = border_class
        render(table, options)
      end

      # Render a given table and return the string representation.
      #
      # @return [String]
      #
      # @api public
      def self.render(table, options={})
        renderer = pick_renderer(options[:renderer]).new(table, options)
        yield renderer if block_given?
        renderer.render
      end
    end # Renderer

  end # Table
end # TTY
