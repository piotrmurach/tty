# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A set of header elements that correspond with values in each row
    class Header < Vector

      def initialize(attributes=[])
        @attributes = attributes
        @attribute_for = Hash[@attributes.map.with_index.to_a]
        super(attributes)
      end

      # Lookup a column in the header given a name
      #
      # @api public
      def call(name)
        @attribute_for.fetch(name) do |header_name|
          raise ArgumentError, "the header '#{header_name}' is unknown"
        end
      end

      def ==(other)
        @attributes === other
      end

      def eql?(other)
        @attributes.eql? other
      end

    end # Header
  end # Table
end # TTY
