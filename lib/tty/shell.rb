# -*- encoding: utf-8 -*-

module TTY

  # A class responsible for shell prompt interactions.
  class Shell

    # @api private
    attr_reader :input

    # @api private
    attr_reader :output

    # @api private
    attr_reader :prefix

    # Initialize a Shell
    #
    # @api public
    def initialize(input=stdin, output=stdout, options={})
      @input  = input
      @output = output
      @prefix = options.fetch(:prefix) { '' }
    end

    # Ask a question.
    #
    # @example
    #   shell = TTY::Shell.new
    #   shell.ask("What is your name?")
    #
    # @param [String] statement
    #   string question to be asked
    #
    # @yieldparam [TTY::Question] question
    #   further configure the question
    #
    # @yield [question]
    #
    # @return [TTY::Question]
    #
    # @api public
    def ask(statement, *args, &block)
      options = Utils.extract_options!(args)

      question = Question.new self, options
      question.instance_eval(&block) if block_given?
      question.prompt(statement)
    end

    # A shortcut method to ask the user positive question and return 
    # true for 'yes' reply.
    #
    # @return [Boolean]
    #
    # @api public
    def yes?(statement, *args, &block)
      ask(statement, *args, &block).read_bool
    end

    # A shortcut method to ask the user negative question and return
    # true for 'no' reply.
    #
    # @return [Boolean]
    #
    # @api public
    def no?(statement, *args, &block)
      !yes?(statement, *args, &block)
    end

    # Print statement out. If the supplied message ends with a space or
    # tab character, a new line will not be appended.
    #
    # @example
    #   say("Simple things.")
    #
    # @param [String] message
    #
    # @return [String]
    #
    # @api public
    def say(message="", options={})
      message = message.to_str
      return unless message.length > 0

      statement = Statement.new(self, options)
      statement.declare message
    end

    # Print statement(s) out in red green.
    #
    # @example
    #   shell.confirm "Are you sure?"
    #   shell.confirm "All is fine!", "This is fine too."
    #
    # @param [Array] messages
    #
    # @return [Array] messages
    #
    # @api public
    def confirm(*args)
      options = Utils.extract_options!(args)
      args.each { |message| say message, options.merge(:color => :green) }
    end

    # Print statement(s) out in yellow color.
    #
    # @example
    #   shell.warn "This action can have dire consequences"
    #   shell.warn "Carefull young apprentice", "This is potentially dangerous."
    #
    # @param [Array] messages
    #
    # @return [Array] messages
    #
    # @api public
    def warn(*args)
      options = Utils.extract_options!(args)
      args.each { |message| say message, options.merge(:color => :yellow) }
    end

    # Print statement(s) out in red color.
    #
    # @example
    #   shell.error "Shutting down all systems!"
    #   shell.error "Nothing is fine!", "All is broken!"
    #
    # @param [Array] messages
    #
    # @return [Array] messages
    #
    # @api public
    def error(*args)
      options = Utils.extract_options!(args)
      args.each { |message| say message, options.merge(:color => :red) }
    end

    # Takes the string provided by the user and compare it with other possible
    # matches to suggest an unambigous string
    #
    # @example
    #   shell.suggest('sta', ['status', 'stage', 'commit', 'branch'])
    #   # => "status, stage"
    #
    # @param [String] message
    #
    # @param [Array] possibilities
    #
    # @param [Hash] options
    # @option options [String] :indent
    #   The number of spaces for indentation
    # @option options [String] :single_text
    #   The text for a single suggestion
    # @option options [String] :plural_text
    #   The text for multiple suggestions
    #
    # @return [String]
    #
    # @api public
    def suggest(message, possibilities, options={})
      suggestion = Suggestion.new(options)
      say(suggestion.suggest(message, possibilities))
    end

    # Print a table to shell.
    #
    # @return [undefined]
    #
    # @api public
    def print_table(*args, &block)
      table = TTY::Table.new *args, &block
      say table.to_s
    end

    # Check if outputing to shell
    #
    # @return [Boolean]
    #
    # @api public
    def tty?
      stdout.tty?
    end

    def stdin
      $stdin
    end

    def stdout
      $stdout
    end

    def stderr
      $stderr
    end

  end # Shell
end # TTY
