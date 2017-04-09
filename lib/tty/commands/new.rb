# encoding: utf-8

require_relative '../command'

module TTY
  module Commands
    class New < Command

      def initialize(app_name, options)
        @app_name = app_name
      end

      def template_source_path
      end

      # Execute the command
      #
      # @api public
      def execute
        puts "Creating gem '#{@app_name}'"
      end
    end # New
  end # Commands
end # TTY
