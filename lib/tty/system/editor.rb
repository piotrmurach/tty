# encoding: utf-8

require 'shellwords'

module TTY
  class System
    # A class responsible for launching an editor
    #
    # @api private
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
        [ENV['VISUAL'], ENV['EDITOR'], 'vi', 'emacs']
      end

      # Find available command
      #
      # @param [Array[String]] commands
      #
      # @return [String]
      #
      # @api public
      def self.available(*commands)
        commands = commands.empty? ? executables : commands
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
        @command = if @command && commands.empty?
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
        unless command
          fail CommandInvocationError, 'Please export $VISUAL or $EDITOR'
        end

        new(file).invoke
      end

      # Build invocation command for editor
      #
      # @return [String]
      #
      # @api private
      def build
        "#{Editor.command} #{escape_file}"
      end

      # Escape file path
      #
      # @api private
      def escape_file
        if System.unix?
          # Escape file string so it can be safely used in a Bourne shell
          Shellwords.shellescape(file)
        elsif System.windows?
          file.gsub(/\//, '\\')
        else
          file
        end
      end

      # Inovke editor command in a shell
      #
      # @raise [TTY::CommandInvocationError]
      #
      # @api private
      def invoke
        command_invocation = build
        status = system(*Shellwords.split(command_invocation))
        return status if status
        fail CommandInvocationError, "`#{command_invocation}` failed with status: #{$? ? $?.exitstatus : nil}"
      end
    end # Editor
  end # System
end # TTY
