# -*- encoding: utf-8 -*-

module TTY

  # A class providing logging system
  class Logger
    include TTY::Equatable

    ALL       = 0
    INFO      = 1
    DEBUG     = 2
    WARN      = 3
    ERROR     = 4
    FATAL     = 5
    OFF       = 6

    MAX_LEVELS = 7

    attr_reader :namespace

    attr_reader :level

    attr_reader :output

    attr_reader :timestamp_format

    # Initialize a Logger
    #
    # @param [String] name
    #
    # @param [Hash] options
    #
    # @option options [String] :output
    #
    # @api public
    def initialize(options={})
      @namespace = options.fetch(:namespace) { raise ArgumentError, "Logger must have namespace", caller }
      @output = options.fetch(:output) { $stderr }
      @level  = options.fetch(:level) { ALL }
      @timestamp_format = options.fetch(:timestamp_format) { '%Y-%m-%d %T' }
    end

    def level=(level)
      validate_level(level)
      @level = level
    end

    # @api public
    def timestamp
      Time.now.strftime(timestamp_format)
    end

    def validate_level(level)
      unless valid_level?(level)
        raise ArgumentError, "Log level must be 0..#{MAX_LEVELS}", caller
      end
    end

    def self.valid_level?(level)
      !level.nil? && level.kind_of?(Numeric) && level >= ALL && level <= OFF
    end

    # Print formatted log to output
    #
    # @api public
    def log(message)
      output.print timestamp + ' - ' + message
    end

  end # Logger
end # TTY
