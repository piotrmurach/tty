# -*- encoding: utf-8 -*-

module TTY
  # A mixin to provide unicode support.
  module Unicode

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

  end # Unicode
end # TTY
