# encoding: utf-8
# frozen_string_literal: true

require 'tty-file'

require_relative 'path_helpers'

module TTY
  class Templater
    include PathHelpers

    attr_reader :templates

    def initialize(source_path, target_path)
      @source_path = templates_root_path.join(source_path)
      @target_path = target_path
      @templates = []
    end

    # The root path for all the templates
    #
    # @api public
    def templates_root_path
      Pathname(__dir__).join('templates')
    end

    # Add mapping to templates
    #
    # @param [String] source
    #   the source template location
    # @param [String] target
    #   the target template location
    #
    # @api public
    def add_mapping(source, target)
      @templates << [source, target]
    end

    # Process templates by injecting vars and moving to location
    #
    # @api private
    def generate(template_options, color_option)
      templates.each do |src, dst|
        source      = @source_path.join(src)
        destination = @target_path.join(dst).to_s
        next unless ::File.exist?(source)
        within_root_path do
          TTY::File.copy_file(source, destination,
                    { context: template_options }.merge(color_option))
        end
      end
    end
  end # Templater
end # TTY
