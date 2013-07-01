# -*- encoding: utf-8 -*-

require 'shellwords'

module TTY
  class System

    # A class responsible for launching an editor
    class Editor

      attr_reader :file

      # Initialize an Editor
      #
      # @param [String] file
      #
      # @api public
      def initialize(file)
        @file = file
      end

      # List possible executable for editor command
      #
      # @return [Array[String]]
      #
      # @api private
      def self.executables
        [ ENV['VISUAL'], ENV['EDITOR'], 'vi', 'emacs' ]
      end

      # Find available command
      #
      # @param [Array[String]] commands
      #
      # @return [String]
      #
      # @api public
      def self.available(*commands)
        commands = commands.empty? ? self.executables : commands
        commands.compact.uniq.find { |cmd| System.exists?(cmd) }
      end

      # Finds command using a configured command(s) or detected shell commands.
      #
      # @param [Array[String]] commands
      #
      # @return [String]
      #
      # @api public
      def self.command(*commands)
        @command = if (@command && commands.empty?)
          @command
        else
          available(*commands)
        end
      end

      # Open file in system editor
      #
      # @param [String] file
      #   the name of the file
      #
      # @raise [TTY::CommandInvocationError]
      #
      # @return [Object]
      #
      # @api public
      def self.open(file)
        unless self.command
          raise CommandInvocationError, "Please export $VISUAL or $EDITOR"
          exit 1
        end

        new(file).invoke
      end

      # Build invocation command for editor
      #
      # @return [String]
      #
      # @api private
      def build
        escaped_file = if System.unix?
          # Escape file string so it can be safely used in a Bourne shell
          Shellwords.shellescape(file)
        elsif System.windows?
          file.gsub(/\//, '\\')
        else
          file
        end
        "#{Editor.command} #{escaped_file}"
      end

      # Inovke editor command in a shell
      #
      # @raise [TTY::CommandInvocationError]
      #
      # @api private
      def invoke
        command_invocation = build
        status = system(*Shellwords.split(command_invocation))

        unless status
          raise CommandInvocationError, "`#{command_invocation}` failed with status: #{$? ? $?.exitstatus : nil}"
          exit status
        end
      end

    end # Editor
  end # System
end # TTY
