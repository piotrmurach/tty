# -*- encoding: utf-8 -*-

module TargetSpec
  class Object
    def output; end
  end
end

module DelegetableSpec
  class Object
    extend TTY::Delegatable

    def test
      TargetSpec::Object.new
    end
  end
end
