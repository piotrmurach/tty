# encoding: utf-8
# frozen_string_literal: true

module TTY
  class Gemspec
    # The gemspec content
    attr_accessor :content

    # The gemspec variable name
    attr_accessor :var_name

    # The gemspec indentation before variable name
    attr_accessor :pre_indent

    attr_accessor :post_indent

    def read(path)
      self.content = ::File.read(path.to_s)
      self.var_name = content.match(/(\w+)\.name/)[1]
      matches = content.match(/^(\s*)#{var_name}\.name(\s*)=.*$/)
      self.pre_indent  = matches[1].size
      self.post_indent = matches[2].size - ('license'.size - 'name'.size)
    end

    def write(path)
      ::File.write(path, content)
    end
  end # Gemspec
end # TTY
