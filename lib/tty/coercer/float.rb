# -*- encoding: utf-8 -*-

module TTY
  class Coercer

      class Float

        def self.coerce(value, strict=true)
          begin
            Kernel.send(:Float, value.to_s)
          rescue
            if strict
              raise InvalidArgument, "#{value} could not be coerced into Float"
            else
              value.to_f
            end
          end
        end

      end # Float

  end # Coercer
end # TTY
