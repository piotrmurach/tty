# encoding: utf-8
# frozen_string_literal: true

require 'thor'

require_relative 'commands/new'

module TTY
  # Main CLI runner
  # @api public
  class CLI < Thor
    Error = Class.new(StandardError)

    no_commands do
      def self.logo
        <<-EOS
     ┏━━━┓
  ┏━┳╋┳┳━┻━━┓
  ┣━┫┗┫┗┳┳┳━┫
  ┃ ┃┏┫┏┫┃┃★┃
  ┃ ┗━┻━╋┓┃ ┃
  ┗━━━━━┻━┻━┛
EOS
      end
    end

    class_option :"no-color", type: :boolean, default: false,
                              desc: 'Disable colorization in output'
    class_option :"dry-run", type: :boolean, aliases: ['-r'],
                             desc: 'Run but do not make any changes.'
    class_option :debug, type: :boolean, default: false,
                         desc: 'Run with debug logging.'

    def self.help(shell, subcommand = false)
      require 'pastel'
      pastel = Pastel.new
      puts pastel.red(logo)
      super
    end

    desc 'version', 'tty version'
    def version
      require_relative 'version'
      puts "v#{TTY::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'new PROJECT_NAME [OPTIONS]', 'Create a new command line app skeleton.'
    long_desc <<-D
      The 'rtty new' command creates a new command line application
      with a default directory structure and configuration at the
      specified path.
    D
    method_option :coc, type: :boolean, default: true,
                        desc: 'Generate a code of conduct file.'
    method_option :force, type: :boolean, aliases: '-f',
                          desc: 'Overwrite existing files.'
    method_option :help, aliases: '-h', desc: 'Display usage information'
    method_option :test, aliases: '-t', desc: 'Project test framework'
    def new(app_name = nil)
      if options[:help]
        invoke :help, ['new']
      elsif app_name.nil?
        raise Error, "'rtty new' was called with no arguments\n" \
                     "Usage: 'rtty new PROJECT_NAME'"
      else
        TTY::Commands::New.new(app_name, options).execute
      end
    end
  end # CLI
end # TTY
