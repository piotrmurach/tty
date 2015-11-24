# encoding: utf-8

module TTY
  class Terminal
    # A class responsible for locating user home
    class Home
      # @api public
      def initialize(platform = nil)
        @platform = platform || TTY::Platform
      end

      # Find user home
      #
      # @api public
      def find_home
        path = @platform.windows? ? windows_home : unix_home
        File.expand_path(path)
      end

      def unix_home
        require 'etc'
        "~#{Etc.getlogin}"
      rescue
        ENV['HOME']
      end

      def windows_home
        if (home = ENV['HOME'])
          home.tr('\\', '/')
        elsif ENV['HOMEDRIVE'] && ENV['HOMEPATH']
          File.join(ENV['HOMEDRIVE'], ENV['HOMEPATH'])
        elsif ENV['USERPROFILE']
          ENV['USERPROFILE']
        elsif ENV['HOMEDRIVE'] || ENV['SystemDrive']
          File.join(ENV['HOMEDRIVE'] || ENV['SystemDrive'], '/')
        else
          'C:/'
        end
      end
    end # Home
  end # Terminal
end # TTY
