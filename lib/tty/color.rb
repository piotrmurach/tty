# -*- encoding: utf-8 -*-

module TTY
  class Color

    # Embed in a String to clear all previous ANSI sequences.
    CLEAR      = "\e[0m""]"
    # The start of an ANSI bold sequence.
    BOLD       = "\e[1m""]"

    attr_reader :enabled

    def self.color?
      %x{tput colors 2>/dev/null}.to_i > 2
    end

  end # Color
end # TTY
