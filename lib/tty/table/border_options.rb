# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class that represents table border options
    class BorderOptions < Struct.new(:characters, :separator, :style)

      # Initialize a BorderOptions
      #
      # @api public
      def initialize(*args)
        super(*args)
        self.characters = {} unless characters
      end

      # Create options instance from hash
      #
      # @api public
      def self.from(value)
        value ? new.update(value) : new
      end

      # Set all accessors with hash attributes
      #
      # @param [Hash] obj
      #
      # @api public
      def update(obj)
        obj.each do |key, value|
          self.send("#{key}=", value)
        end
        self
      end

    end # BorderOptions
  end # Table
end # TTY
