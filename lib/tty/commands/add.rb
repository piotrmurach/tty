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
        opts[:app_indent] = '  ' * app_name_constantinized.split('::').size
        opts[:cmd_indent] = '  ' * cmd_name_constantinized.split('::').size
        opts[:cmd_file_path] = cmd_file_path
        opts
      end

      def color_option
        options['no-color'] ? { color: false } : {}
      end

      def execute
        validate_cmd_name(cmd_name)

        @templater.add_mapping("command.rb.tt",
          "lib/#{app_name}/commands/#{cmd_name_underscored}.rb")

        @templater.generate(template_options, color_option)
      end

      private

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

      def cmd_file_path
        '../' * cmd_name_constantinized.split('::').size + 'cmd'
      end

      def spec_root
        Pathname.new('spec')
      end
    end # Add
  end # Commands
end # TTY
