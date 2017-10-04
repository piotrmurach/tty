# encoding: utf-8
# frozen_string_literal: true

require 'ostruct'

require_relative '../cmd'
require_relative '../templater'

module TTY
  module Commands
    class Add < TTY::Cmd
      include PathHelpers

      attr_reader :app_name

      attr_reader :cmd_name

      attr_reader :options

      def initialize(cmd_names, options)
        @cmd_name = cmd_names[0]
        @app_path = relative_path_from(root_path, root_path)
        @app_name = name_from_path(root_path)
        @options  = options

        @templater = Templater.new('add', @app_path)
      end

      def template_options
        opts = OpenStruct.new
        opts[:app_name_constantinized] = app_name_constantinized
        opts[:cmd_name_constantinized] = cmd_name_constantinized
        opts[:app_name_underscored] = app_name_underscored
        opts[:cmd_name_underscored] = cmd_name_underscored
        opts[:app_constantinized_parts] = app_name_constantinized.split('::')
        opts[:cmd_constantinized_parts] = cmd_name_constantinized.split('::')
        opts[:app_indent] = app_indent
        opts[:cmd_indent] = '  ' * cmd_name_constantinized.split('::').size
        opts[:cmd_file_path] = cmd_file_path
        opts
      end

      def color_option
        options['no-color'] ? { color: false } : {}
      end

      def execute
        validate_cmd_name(cmd_name)

        @templater.add_mapping('command.rb.tt',
          "lib/#{app_name}/commands/#{cmd_name_underscored}.rb")

        @templater.generate(template_options, color_option)

        target_cli = ::File.read("lib/#{app_name}/cli.rb")
        match = cmd_matches.find { |m| target_cli =~ m }
        generator.inject_into_file(
          "lib/#{app_name}/cli.rb",
          "\n#{cmd_template}",
          {after: match}.merge(color_option))
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

      private

      def cmd_template
<<-EOS
#{app_indent}  desc '#{cmd_name_underscored}', 'Command description...'
#{app_indent}  def #{cmd_name_underscored}(*)
#{app_indent}    if options[:help]
#{app_indent}      invoke :help, ['#{cmd_name}']
#{app_indent}    else
#{app_indent}      require_relative 'commands/#{cmd_name_path}'
#{app_indent}      #{cmd_object}.new(options).execute
#{app_indent}    end
#{app_indent}  end
EOS
      end

      def app_indent
        '  ' * app_name_constantinized.split('::').size
      end

      def cmd_object
        "#{app_name_constantinized}::Commands::#{cmd_name_constantinized}"
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
        cmd_name.tr('-', '/')
      end

      def cmd_file_path
        '../' * cmd_name_constantinized.split('::').size + 'cmd'
      end

      def spec_root
        Pathname.new('spec')
      end
    end # Add
  end # Commands
end # TTY
