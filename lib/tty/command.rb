# encoding: utf-8

module TTY
  class Command

    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

  end # Command
end # TTY
