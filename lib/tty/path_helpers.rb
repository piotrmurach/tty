# encoding: utf-8
# frozen_string_literal: true

module TTY
  module PathHelpers
    # The root path of the app running this command
    #
    # @return [Pathname]
    #
    # @api public
    def root_path
      @root_path ||= Pathname.pwd
    end

    # Execute command within root path
    #
    # @api public
    def within_root_path(&block)
      Dir.chdir(root_path, &block)
    end

    # Extract name from a path
    #
    # @api public
    def name_from_path(path)
      Pathname(path).basename.to_s
    end

    # Extract a relative path for the app
    #
    # @api private
    def relative_path_from(root_path, path)
      project_path = Pathname.new(path)
      return project_path if project_path.relative?
      project_path.relative_path_from(root_path)
    end
  end # PathHelpers
end # TTY
