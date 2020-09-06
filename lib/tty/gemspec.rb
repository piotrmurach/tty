# frozen_string_literal: true

require "yaml"

require_relative "gemspec_dependency"

module TTY
  class Gemspec
    GEMS_YAML = ::File.expand_path("gems.yml", __dir__)

    OPTIONAL_DEPENDENCIES = YAML.load_file(GEMS_YAML)

    # The gemspec content
    attr_accessor :content

    # The gemspec variable name
    attr_accessor :var_name

    # The gemspec indentation before variable name
    attr_accessor :pre_var_indent

    # The gemspec indentation size afater variable name
    attr_accessor :post_var_indent

    def read(path)
      self.content = ::File.read(path.to_s)
      self.var_name = content.match(/(\w+)\.name/)[1]
      matches = content.match(/^(\s*)#{var_name}(\.name\s*)=.*$/)
      self.pre_var_indent  = matches[1].size
      self.post_var_indent = matches[2].size
    end

    def write(path)
      ::File.write(path, content)
    end

    def format_gem_dependencies(dependencies = gemspec_dependencies)
      gems = []
      indent = " " * pre_var_indent
      dependencies.each do |gem|
        if gem.comment
          gems << "\n#{indent}# #{gem.comment}"
        end

        dependency = [indent]
        dependency << (gem.optional? ? "# " : "")
        dependency << "#{var_name}.add_dependency "
        dependency << "\"#{gem.name}\""
        dependency << ", \"#{gem.version}\"" if gem.version
        gems << dependency.join
      end
      gems.join("\n")
    end

    private

    # @api private
    def gemspec_dependencies
      [
        thor_gemspec_dependency,
        pastel_gemspec_dependency,
        *optional_gemspec_dependencies
      ]
    end

    # @api private
    def thor_gemspec_dependency
      GemspecDependency.new("thor", "~> 1.0")
    end

    # @api private
    def pastel_gemspec_dependency
      GemspecDependency.new("pastel", "~> 0.8")
    end

    # @api private
    def optional_gemspec_dependencies
      OPTIONAL_DEPENDENCIES.map do |attrs|
        GemspecDependency.optional(
          attrs["name"], attrs["version"], attrs["comment"]
        )
      end
    end
  end # Gemspec
end # TTY
