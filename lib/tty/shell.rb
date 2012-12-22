# -*- encoding: utf-8 -*-

module TTY

  # A class responsible for shell prompt interactions.
  class Shell

    # @api private
    attr_reader :input

    # @api private
    attr_reader :output

    # Initialize a Shell
    #
    # @api public
    def initialize(input=stdin, output=stdout)
      @input  = input
      @output = output
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

      question = Question.new input, output
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

    # Print statement out.
    #
    # @example
    #   say("Simple things.")
    #
    # @api public
    def say(message="", color=nil)
      message = message.to_str

      if /( |\t)\Z/ =~ message
        output.print message
      else
        output.puts message
      end
      output.flush
    end

    # Print a table to shell.
    #
    # @return [undefined]
    #
    # @api public
    def print_table(*args, &block )
      output.print TTY::Table.new *args, &block
    end

    protected

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
