# frozen_string_literal: true

module TTY
  class GemspecDependency
    attr_reader :name, :version, :comment

    def self.optional(name, version, comment)
      new(name, version, comment: comment, optional: true)
    end

    def initialize(name, version, comment: nil, optional: false)
      @name = name
      @version = version
      @comment = comment
      @optional = optional
    end

    def optional?
      @optional
    end
  end # GemspecDependency
end # TTY
