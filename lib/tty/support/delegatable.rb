# encoding: utf-8

module TTY
  # A mixin to allow delegetable methods to be added
  module Delegatable
    # Create delegator for each specified method
    #
    # @example
    #   delegatable_method :source, :method
    #
    # @param [Symbol] source
    #
    # @param [Array] methods
    #
    # @return [self]
    #
    # @api public
    def delegatable_method(source, *methods)
      methods.each do |method|
        define_delegatable_method(source, method)
      end
      self
    end

    private

    # Create a delegator method for the method name
    #
    # @param [Symbol] source
    #
    # @param [Symbol] method name
    #
    # @return [undefined]
    #
    # @api private
    def define_delegatable_method(source, method)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(*args, &block)
          #{source}.#{method}(*args, &block)
        end
      RUBY
    end
  end # Delegatable
end # TTY
