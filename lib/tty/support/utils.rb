# encoding: utf-8

module TTY
  module Utils
    extend self

    def extract_options!(args)
      args.last.respond_to?(:to_hash) ? args.pop : {}
    end

    def extract_options(args)
      options = args.last
      options.respond_to?(:to_hash) ? options.to_hash.dup : {}
    end
  end # Utils
end # TTY
