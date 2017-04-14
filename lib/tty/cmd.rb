# encoding: utf-8

require_relative 'sh'

module TTY
  class Cmd

    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end
  end # Cmd
end # TTY
