# encoding: utf-8

module TTY
  class System
    # Proxy to editor object
    #
    # @return [TTY::System::Editor]
    #
    # @api public
    def self.editor
      TTY::System::Editor
    end
  end # System
end # TTY
