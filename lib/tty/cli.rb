# encoding: utf-8
# frozen_string_literal: true

require 'thor'

require_relative 'licenses'

module TTY
  # Main CLI runner
  # @api public
  class CLI < Thor
    extend TTY::Licenses

    # Error raised by this runner
    Error = Class.new(StandardError)

    no_commands do
      def self.logo(banner)
        <<-EOS
    ┏━━━┓
 ┏━┳╋┳┳━┻━━┓
 ┣━┫┗┫┗┳┳┳━┫
 ┃ ┃┏┫┏┫┃┃★┃  #{banner}
 ┃ ┗━┻━╋┓┃ ┃
 ┗━━━━━┻━┻━┛
EOS
      end

      def self.top_banner
        require 'pastel'
        pastel = Pastel.new
        pastel.red(logo('Terminal apps toolkit'))
      end

      def self.executable_name
        ::File.basename($PROGRAM_NAME)
      end
    end

    class_option :"no-color", type: :boolean, default: false,
                              desc: 'Disable colorization in output.'
    class_option :"dry-run", type: :boolean, aliases: ['-r'],
                             desc: 'Run but do not make any changes.'
    class_option :debug, type: :boolean, default: false,
                         desc: 'Run with debug logging.'

    def self.help(*)
      print top_banner
      super
    end

    desc 'add COMMAND [SUBCOMMAND] [OPTIONS]', 'Add a command to the command line app.'
    long_desc <<-D
      The `teletype add` will create a new command and place it into
      appropriate structure in the cli app.

      Example: 
        teletype add config

        This generates a command in app/commands/config.rb

      You can also add subcommands

      Example:
        teletype add config server

        This generates a command in app/commands/config/server.rb
    D
    method_option :help, aliases: '-h', desc: 'Display usage information.'
    def add(*names)
      if options[:help]
        invoke :help, ['add']
      elsif names.size < 1
        fail Error, "'teletype add' was called with no arguments\n" \
                     "Usage: 'teletype add COMMAND_NAME'"
      else
        require_relative 'commands/add'
        TTY::Commands::Add.new(names, options).execute
      end
    end

    desc 'new PROJECT_NAME [OPTIONS]', 'Create a new command line app skeleton.'
    long_desc <<-D
      The 'teletype new' command creates a new command line application
      with a default directory structure and configuration at the
      specified path.

      The PROJECT_NAME will be the name for the directory that includes all the
      files and be the default binary name.

      Example:
        teletype new cli_app
    D
    method_option :author, type: :array, aliases: '-a',
                           desc: 'Author(s) of this library',
                           banner: 'name1 name2'
    method_option :ext, type: :boolean, default: false,
                        desc: 'Generate a boilerpalate for C extension.'
    method_option :coc, type: :boolean, default: true,
                        desc: 'Generate a code of conduct file.'
    method_option :force, type: :boolean, aliases: '-f',
                          desc: 'Overwrite existing files.'
    method_option :help, aliases: '-h', desc: 'Display usage information.'
    method_option :license, type: :string, default: 'mit', banner: 'mit',
                            aliases: '-l', desc: 'Generate a license file.',
                            enum: licenses.keys.concat(['custom'])
    method_option :test, type: :string, default: 'rspec',
                         aliases: '-t', desc: 'Generate a test setup.',
                         banner: 'rspec', enum: %w(rspec minitest)
    def new(app_name = nil)
      if options[:help]
        invoke :help, ['new']
      elsif app_name.nil?
        fail Error, "'teletype new' was called with no arguments\n" \
                     "Usage: 'teletype new PROJECT_NAME'"
      else
        require_relative 'commands/new'
        TTY::Commands::New.new(app_name, options).execute
      end
    end

    desc 'version', 'TTY version'
    def version
      require_relative 'version'
      puts "v#{TTY::VERSION}"
    end
    map %w(--version -v) => :version
  end # CLI
end # TTY
