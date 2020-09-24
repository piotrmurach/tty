# frozen_string_literal: true

require "pastel"
require "pathname"
require "ostruct"
require "shellwords"

require_relative "../cmd"
require_relative "../gemspec"
require_relative "../licenses"
require_relative "../plugins"
require_relative "../templater"
require_relative "../version"


module TTY
  module Commands
    # The `new` command
    #
    # @api private
    class New < TTY::Cmd
      include TTY::Licenses

      # @api private
      attr_reader :app_name

      attr_reader :app_path

      # @api private
      attr_reader :options

      # @api private
      attr_reader :target_path

      attr_reader :templates

      def initialize(app_path, options)
        @app_path = relative_path_from(root_path, app_path)
        @app_name = name_from_path(app_path)
        @options  = options
        @pastel   = Pastel.new(enabled: !options["no-color"])

        @target_path = root_path.join(@app_path)
        @templater = Templater.new(command_path, @app_path)
        @runner = command(printer: :null)
      end

      def git_exist?
        exec_exist?("git")
      end

      def git_author
        git_exist? ? `git config user.name`.chomp : ""
      end

      def author
        if !Array(options["author"]).empty?
          options["author"].join(", ")
        elsif !git_author.empty?
          git_author
        else
          "TODO: Write your name"
        end
      end

      def namespaced_path
        app_name.tr("-", "/")
      end

      def underscored_name
        app_name.tr("-", "_")
      end

      def constantinized_name
        constantinize(app_name)
      end

      def template_context
        opts = OpenStruct.new
        opts[:app_name] = app_name
        opts[:author]   = author
        opts[:namespaced_path]  = namespaced_path
        opts[:underscored_name] = underscored_name
        opts[:constantinized_name] = constantinized_name
        opts[:constantinized_parts] = constantinized_name.split("::")
        opts[:indent] = "  " * constantinized_name.split("::").size
        opts
      end

      def file_options
        opts = {}
        opts[:force] = true if options["force"]
        opts[:color] = false if options["no-color"]
        opts
      end

      def gemspec_name
        "#{app_name}.gemspec"
      end

      def gemspec_path
        target_path.join("#{app_name}.gemspec").to_s
      end

      # Execute the command
      #
      # @api public
      def execute(input: $stdin, output: $stdout)
        output.puts "OPTS: #{options}" if options["debug"]

        coc_opt  = options["coc"] ? "--coc" : "--no-coc"
        ext_opt  = options["ext"] ? "--ext" : "--no-ext"
        test_opt = options["test"]
        command = [
          "bundle gem #{target_path.to_s.shellescape}",
          "--no-mit",
          "--no-exe",
          coc_opt,
          ext_opt,
          "-t #{test_opt}"
        ].join(" ")

        install_info = []

        @runner.run(command) do |out, err|
          next unless out
          out.each_line do |line|
            if line =~ /^Initializing git/
              install_info << line.rstrip.dup
              next
            elsif line =~ /^(Gem.*?was successfully created)/
              next
            end

            if !options["no-color"]
              output.puts color_actions(line.rstrip)
            else
              output.puts line.rstrip
            end
          end
        end

        add_app_templates
        add_empty_directories
        add_dependencies_to_gemspec
        @templater.generate(template_context, file_options)
        make_executable
        output.puts install_info.join("\n") unless install_info.empty?

        output.print "\n" + @pastel.green("Your teletype project has been created successfully in directory \"#{app_path}\".\n")
        output.print "\n" + @pastel.yellow("Before you can begin working, you'll need to modify the \"#{app_path}.gemspec\" file:\n")
        output.print @pastel.yellow("  - Replace all TODO: text with valid information (summary, description, etc)\n")
        output.print @pastel.yellow("  - Replace all metadata information (URIs, hosts) with valid URLs, or delete them\n")
        output.print @pastel.yellow("  - Uncomment any 'spec.add_dependency' lines for tty-* libs you plan on using\n")
        output.print "\n" + @pastel.green("Then, you can run \"teletype help\" for more commands.\n")
      end

      private

      def color_actions(out)
        out.gsub(/^(\s+)(create)/, "\1" + @pastel.green("\2"))
           .gsub(/^(\s+)(identical)/, "\1" + @pastel.blue("\2"))
           .gsub(/^(\s+)(conflict)/, "\1" + @pastel.red("\2"))
           .gsub(/^(\s+)(forced|skipped)/, "\1" + @pastel.yellow("\2"))
      end

      def make_executable
        exec_path = target_path.join("exe/#{app_name}")
        exec_path.chmod(exec_path.stat.mode | 0o111)
      end

      def add_app_templates
        @templater.add_mapping("lib/newcli/cli.rb.tt",
                               "lib/#{namespaced_path}/cli.rb")
        @templater.add_mapping("lib/newcli/command.rb.tt",
                               "lib/#{namespaced_path}/command.rb")
        @templater.add_mapping("exe/newcli.tt", "exe/#{app_name}")

        license = options["license"] == "none" ? false : options["license"]
        if license
          @templater.add_mapping("#{license}_LICENSE.txt.tt", "LICENSE.txt")
          add_license_to_gemspec(license)
          add_license_to_readme(license)
        end
      end

      def test_dir
        options["test"] == "rspec" ? "spec" : "test"
      end

      def add_empty_directories
        @templater.add_empty_directory_mapping("lib/#{namespaced_path}/commands")
        @templater.add_empty_directory_mapping("lib/#{namespaced_path}/templates")
        @templater.add_empty_directory_mapping("#{test_dir}/integration")
        @templater.add_empty_directory_mapping("#{test_dir}/support")
        @templater.add_empty_directory_mapping("#{test_dir}/unit")
      end

      # Add license definition to gemspec
      #
      # @api private
      def add_license_to_gemspec(license)
        gemspec = TTY::Gemspec.new
        gemspec.read(gemspec_path)
        license_regex = /(^\s*#{gemspec.var_name}\.license\s*=\s*).*/

        if gemspec.content =~ license_regex
          gemspec.content.gsub!(liecense_regex,
                                "\\1\"#{licenses[license][:name]}\"")
        else
          gem_license = " " * gemspec.pre_var_indent
          gem_license << "#{gemspec.var_name}.license"
          gem_license << " " * (gemspec.post_var_indent - ".license".size)
          gem_license << "= \"#{licenses[license][:name]}\""
          gemspec.content.gsub!(/(^\s*#{gemspec.var_name}\.name\s*=\s*.*$)/,
                                "\\1\n#{gem_license}")
        end
        gemspec.write(gemspec_path)
      end

      def add_license_to_readme(license)
        desc = licenses[license][:desc]
        readme_path = Dir["#{app_path}/README*"].first
        content = "\n## Copyright\n\n" \
                  "Copyright (c) #{Time.now.year} #{author}. "\
                  "See [#{desc}](LICENSE.txt) for further details."
        within_root_path do
          generator.append_to_file(readme_path, content, **file_options)
        end
      end

      def add_dependencies_to_gemspec
        gemspec = TTY::Gemspec.new
        gemspec.read(gemspec_path)
        content = "\n#{gemspec.format_gem_dependencies}\n"

        within_root_path do
          path = app_path.join(gemspec_name)
          generator.inject_into_file(path, content,
                                     **{ before: /^end$/ }.merge(file_options))
        end
      end
    end # New
  end # Commands
end # TTY
