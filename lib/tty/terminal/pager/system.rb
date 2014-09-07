# encoding: utf-8

module TTY
  class Terminal
    # A class responsible for paging text
    class SystemPager < Pager
      # Use system command to page output text
      #
      # @api public
      def page
        read_io, write_io = IO.pipe

        if Kernel.fork
          # parent process
          TTY.shell.input.reopen(read_io)
          read_io.close
          write_io.close

          # Wait until we have input before we start the pager
          Kernel.select [TTY.shell.stdin]

          begin
            Kernel.exec(Pager.command)
          rescue
            Kernel.exec '/bin/sh', '-c', command
          end
        else
          # child process
          write_io.write(text)
          write_io.close
          read_io.close
        end
      end
    end # SystemPager
  end # Terminal
end # TTY
