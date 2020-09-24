# frozen_string_literal: true

require "ostruct"

require_relative "../cmd"
require_relative "../templater"

module TTY
  module Commands
    class Add < TTY::Cmd
      include PathHelpers

      attr_reader :app_name

      attr_reader :cmd_name

      attr_reader :subcmd_name

      attr_reader :options

      def initialize(cmd_names, options)
        @cmd_name = cmd_names[0]
        @subcmd_name = cmd_names[1]
        @app_path = relative_path_from(root_path, root_path)
        @app_name = name_from_path(root_path)
        @options  = options
        @pastel   = Pastel.new(enabled: !options["no-color"])

        @templater = Templater.new(command_path, @app_path)
      end

      def namespaced_path
        app_name.tr("-", "/")
      end

      def template_context
        opts = OpenStruct.new
        opts[:cmd_options] = cmd_options
        opts[:cmd_object_parts] = cmd_object_parts
        opts[:cmd_desc_args] = cmd_desc_args
        opts[:cmd_desc] = cmd_desc
        opts[:app_indent] = app_indent
        opts[:cmd_indent] = cmd_indent
        opts[:cmd_path] = "#{namespaced_path}/commands/#{cmd_name_path}"
        opts[:subcmd_path] = subcmd_name &&
          "#{namespaced_path}/commands/#{cmd_name_path}/#{subcmd_name_path}"
        opts[:cmd_name_constantinized] = cmd_name_constantinized
        opts[:subcmd_name_constantinized] = subcmd_name && subcmd_name_constantinized
        opts[:app_name_underscored] = app_name_underscored
        opts[:cmd_name_underscored] = cmd_name_underscored
        opts[:subcmd_name_underscored] = subcmd_name && subcmd_name_underscored
        opts[:app_constantinized_parts] = app_name_constantinized.split("::")
        opts[:cmd_constantinized_parts] = cmd_constantinized_parts
        opts[:cmd_file_path] = cmd_file_path
        opts
      end

      def file_options
        opts = {}
        opts[:force] = true if options["force"]
        opts[:color] = false if options["no-color"]
        opts
      end

      def execute(input: $stdin, output: $stdout)
        validate_pwd
        validate_cmd_name(cmd_name)

        test_dir = (options["test"] == "rspec") || ::Dir.exist?("spec") ? "spec" : "test"
        cli_file = "lib/#{namespaced_path}/cli.rb"
        cli_content = ::File.read(cli_file)
        cmd_file = "lib/#{namespaced_path}/commands/#{cmd_name_path}.rb"
        cmd_template_path = "lib/#{namespaced_path}/templates/#{cmd_name_path}"

        cmd_integ_test_file = "#{test_dir}/integration/#{cmd_name_path}_#{test_dir}.rb"
        cmd_unit_test_file = "#{test_dir}/unit/#{cmd_name_path}_#{test_dir}.rb"

        unless subcmd_present?
          @templater.add_mapping(
            "#{test_dir}/integration/command_#{test_dir}.rb.tt",
            "#{test_dir}/integration/#{cmd_name_path}_#{test_dir}.rb")
          @templater.add_mapping("#{test_dir}/unit/command_#{test_dir}.rb.tt",
            "#{test_dir}/unit/#{cmd_name_path}_#{test_dir}.rb")
          @templater.add_mapping("command.rb.tt", cmd_file)
          @templater.add_empty_directory_mapping(cmd_template_path)
          @templater.generate(template_context, file_options)

          unless cmd_exists?(cli_content)
            match = cmd_matches.find { |m| cli_content =~ m }
            generator.inject_into_file(
              cli_file, "\n#{cmd_template}",
              **{after: match}.merge(file_options))
          end
        else
          subcmd_file = "lib/#{namespaced_path}/commands/#{cmd_name_path}/#{subcmd_name_path}.rb"
          subcmd_template_path = "lib/#{namespaced_path}/templates/#{cmd_name_path}/#{subcmd_name_path}"
          unless ::File.exists?(cmd_integ_test_file)
            @templater.add_mapping(
              "#{test_dir}/integration/command_#{test_dir}.rb.tt",
              cmd_integ_test_file)
          end
          unless ::File.exists?(cmd_unit_test_file)
            @templater.add_mapping(
              "#{test_dir}/unit/#{cmd_name_path}_#{test_dir}.rb",
              cmd_unit_test_file
            )
          end
          @templater.add_mapping(
            "#{test_dir}/integration/sub_command_#{test_dir}.rb.tt",
            "#{test_dir}/integration/#{cmd_name_path}/#{subcmd_name_path}_#{test_dir}.rb")
          @templater.add_mapping(
            "#{test_dir}/unit/sub_command_#{test_dir}.rb.tt",
            "#{test_dir}/unit/#{cmd_name_path}/#{subcmd_name_path}_#{test_dir}.rb"
          )
          unless ::File.exists?(cmd_file) # namespace already present
            @templater.add_mapping("namespace.rb.tt", cmd_file)
          end
          @templater.add_mapping("command.rb.tt", subcmd_file)
          @templater.add_empty_directory_mapping(subcmd_template_path)
          @templater.generate(template_context, file_options)

          if !subcmd_registered?(cli_content)
            match = register_subcmd_matches.find { |m| cli_content =~ m }
            generator.inject_into_file(
              cli_file, "\n#{register_subcmd_template}",
              **{after: match}.merge(file_options))
          end

          content = ::File.read(cmd_file)
          if !subcmd_exists?(content)
            match = subcmd_matches.find {|m| content =~ m }
            generator.inject_into_file(
              cmd_file, "\n#{subcmd_template}",
              **{after: match}.merge(file_options))
          end
        end
      end

      def subcmd_present?
        !subcmd_name.nil?
      end

      def subcmd_registered?(content)
        content =~%r{\s*require_relative 'commands/#{cmd_name_path}'}
      end

      def subcmd_exists?(content)
        content =~ %r{\s*def #{subcmd_name_underscored}.*}
      end

      def cmd_exists?(content)
        content =~ %r{\s*def #{cmd_name_underscored}.*}
      end

      # Matches for inlining command defition in template
      #
      # @api private
      def cmd_matches
        [
          %r{def version.*?:version\n}m,
          %r{def version.*?#{app_indent}  end\n}m,
          %r{class CLI < Thor\n}
        ]
      end

      def subcmd_matches
        [
          %r{namespace .*?\n},
          %r{class .*? < Thor\n}
        ]
      end

      def register_subcmd_matches
        [
          %r{require_relative .*?\nregister .*?\n}m
        ].concat(cmd_matches)
      end

      private

      def cmd_template
<<-EOS
#{app_indent}#{cmd_indent}desc '#{cmd_name_underscored}#{cmd_desc_args}', '#{cmd_desc}'
#{app_indent}#{cmd_indent}method_option :help, aliases: '-h', type: :boolean,
#{app_indent}#{cmd_indent}                     desc: 'Display usage information'
#{app_indent}#{cmd_indent}def #{cmd_name_underscored}(#{cmd_args.join(', ')})
#{app_indent}#{cmd_indent}  if options[:help]
#{app_indent}#{cmd_indent}    invoke :help, ['#{cmd_name_underscored}']
#{app_indent}#{cmd_indent}  else
#{app_indent}#{cmd_indent}    require_relative 'commands/#{cmd_name_path}'
#{app_indent}#{cmd_indent}    #{cmd_object_parts.join('::')}.new(#{cmd_options.join(', ')}).execute
#{app_indent}#{cmd_indent}  end
#{app_indent}#{cmd_indent}end
EOS
      end

      def register_subcmd_template
<<-EOS
#{app_indent}  require_relative 'commands/#{cmd_name_path}'
#{app_indent}  register #{cmd_object_parts[0..-2].join('::')}, '#{cmd_name_underscored}', '#{cmd_name_underscored} [SUBCOMMAND]', '#{cmd_desc}'
EOS
      end

      def subcmd_template
<<-EOS
#{app_indent}#{cmd_indent}desc '#{subcmd_name_underscored}#{cmd_desc_args}', '#{cmd_desc}'
#{app_indent}#{cmd_indent}method_option :help, aliases: '-h', type: :boolean,
#{app_indent}#{cmd_indent}                     desc: 'Display usage information'
#{app_indent}#{cmd_indent}def #{subcmd_name_underscored}(#{cmd_args.join(', ')})
#{app_indent}#{cmd_indent}  if options[:help]
#{app_indent}#{cmd_indent}    invoke :help, ['#{subcmd_name_underscored}']
#{app_indent}#{cmd_indent}  else
#{app_indent}#{cmd_indent}    require_relative '#{cmd_name_path}/#{subcmd_name_path}'
#{app_indent}#{cmd_indent}    #{cmd_object_parts.join('::')}.new(#{cmd_options.join(', ')}).execute
#{app_indent}#{cmd_indent}  end
#{app_indent}#{cmd_indent}end
EOS
      end

      def cmd_desc_args
        return "" unless @options[:args].any?
        " " + @options[:args].map do |arg|
          if arg.start_with?("*")
            arg[1..-1].upcase + "..."
          elsif arg.include?("=")
            "[#{arg.split("=")[0].strip}]"
          else
           arg
          end.upcase
        end.join(" ")
      end

      def cmd_desc
        @options[:desc].nil? ? "Command description..." : @options[:desc]
      end

      def cmd_args
        @options[:args].empty? ? ["*"] : @options[:args]
      end

      def cmd_options
        @options[:args].map do |arg|
          if arg.start_with?("*")
            arg[1..-1]
          elsif arg.include?("=")
            arg.split("=")[0].strip
          else
            arg
          end
        end + ["options"]
      end

      def app_indent
        "  " * app_name_constantinized.split("::").size
      end

      def cmd_indent
        "  " * cmd_constantinized_parts.size
      end

      def cmd_object_parts
        [
          app_name_constantinized,
          "Commands",
          cmd_name && cmd_name_constantinized,
          subcmd_name && subcmd_name_constantinized
        ].compact
      end

      def cmd_constantinized_parts
        [
          cmd_name && constantinize(cmd_name),
          subcmd_name && constantinize(subcmd_name)
        ].compact
      end

      # Make sure the current directory is a teletype project
      # (or, at the very least, contains the correct directory structure)
      #
      def validate_pwd
        fail ::TTY::CLI::Error, @pastel.red("This doesn't look like a teletype app directory - are you in the right place?") unless
          options[:force] || (@app_path + "lib/#{namespaced_path}").exist?
      end

      def validate_cmd_name(cmd_name)
        # TODO: check if command has correct name
      end

      def app_name_constantinized
        constantinize(app_name)
      end

      def app_name_underscored
        snake_case(app_name)
      end

      def cmd_name_constantinized
        constantinize(cmd_name)
      end

      def cmd_name_underscored
        snake_case(cmd_name)
      end

      def cmd_name_path
        cmd_name_underscored.tr("-", "/")
      end

      def cmd_file_path
        "../" * cmd_constantinized_parts.size + "command"
      end

      def subcmd_name_underscored
        snake_case(subcmd_name)
      end

      def subcmd_name_constantinized
        constantinize(subcmd_name)
      end

      def subcmd_name_path
        subcmd_name_underscored.tr("-", "/")
      end

      def spec_root
        Pathname.new("spec")
      end
    end # Add
  end # Commands
end # TTY
