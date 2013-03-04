# -*- encoding: utf-8 -*-

module TTY
  class System

    # A class responsible for finding an executable in the PATH
    class Which

      # Find an executable in the PATH
      #
      # @param [String] command
      #   the command to search in the PATH
      #
      # @example
      #   which("ruby")  # => /usr/local/bin/ruby
      #
      # @return [String]
      #   the full path to executable if found, `nil` otherwise
      #
      # @api public
      def which(command)
        exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
        default_system_path.each do |path|
          exts.each do |ext|
            exec = File.join("#{path}", "#{command}#{ext}")
            return exec if File.executable? exec
          end
        end
        return nil
      end

      # Find default system paths
      #
      # @api private
      def default_system_path
        ENV['PATH'].split(File::PATH_SEPARATOR)
      end

    end # Which
  end # System
end # TTY
