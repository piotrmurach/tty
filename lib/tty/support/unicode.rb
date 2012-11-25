# -*- encoding: utf-8 -*-

module TTY
  # A mixin to provide unicode support.
  module Unicode

    def utf8?(string)
      string.unpack('U*') rescue return false
      true
    end

    def clean_utf8(string)
      require 'iconv'
      if defined? ::Iconv
        converter = Iconv.new('UTF-8//IGNORE', 'UTF-8')
        converter.iconv(string)
      end
    rescue Exception
      string
    end

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
