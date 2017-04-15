# encoding: utf-8

require 'pastel'

require_relative '../cmd'

module TTY
  module Commands
    class New < Cmd

      attr_reader :app_name

      def initialize(app_name, options)
        @app_name = app_name
        @options = options
        @pastel = Pastel.new
      end

      def template_source_path
      end

      # Execute the command
      #
      # @api public
      def execute
        cli_name = ::File.basename(app_name)
        puts "OPTS: #{@options}" if @options['debug']

        coc_opt = @options['coc'] ? '--coc' : '--no-coc'
        command = "bundle gem #{app_name} --no-mit --no-exe #{coc_opt}"

        out, _  = run(command)

        if !@options['no-color']
          out = out.gsub(/^(\s+)(create)/, '\1' + @pastel.green('\2')).
                    gsub(/^(\s+)(identical)/, '\1' + @pastel.yellow('\2'))
        end

        puts out
      end
    end # New
  end # Commands
end # TTY
