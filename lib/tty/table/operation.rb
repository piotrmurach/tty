# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      if "".respond_to?(:encode)
        def as_unicode
          yield
        end
      else
        def as_unicode
          old, $KCODE = $KCODE, "U"
          yield
        ensure
          $KCODE = old
        end
      end

    end # Operation
  end # Table
end # TTY
