# encoding: utf-8
# frozen_string_literal: true

require 'pastel'
require 'pathname'
require 'ostruct'

require_relative '../cmd'
require_relative '../gemspec'
require_relative '../licenses'
require_relative '../plugins'
require_relative '../templater'

module TTY
  module Commands
    # The `new` command
    #
    # @api private
    class New < TTY::Cmd
      include TTY::Licenses

      # @api private
      attr_reader :app_name

      attr_reader :app_path

      # @api private
      attr_reader :options

      # @api private
      attr_reader :target_path

      attr_reader :templates

      def initialize(app_path, options)
        @app_path = resolve_path(app_path)
        @app_name = name_from_path(app_path)
        @options  = options
        @pastel   = Pastel.new

        @target_path = root_path.join(@app_path)
        @templater = Templater.new('new', @app_path)
      end

      # Extract a relative path for the app
      #
      # @api private
      def resolve_path(path)
        project_path = Pathname.new(path)
        return project_path if project_path.relative?
        project_path.relative_path_from(root_path)
      end

      def git_exist?
        exec_exist?('git')
      end

      def git_author
        git_exist? ? `git config user.name`.chomp : ''
      end

      def namespaced_path
        app_name.tr('-', '/')
      end

      def underscored_name
        app_name.tr('-', '_')
      end

      def constantinized_name
        constantinize(app_name)
      end

      def template_options
        opts = OpenStruct.new
        opts[:app_name] = app_name
        opts[:author]   = git_author.empty? ? 'TODO: Write your name' : git_author
        opts[:namespaced_path]  = namespaced_path
        opts[:underscored_name] = underscored_name
        opts[:constantinized_name] = constantinized_name
        opts[:constantinized_parts] = constantinized_name.split('::')
        opts[:indent] = '  ' * constantinized_name.split('::').size
        opts
      end

      def color_option
        options['no-color'] ? { color: false } : {}
      end

      def gemspec_name
        "#{app_name}.gemspec"
      end

      def gemspec_path
        target_path.join("#{app_name}.gemspec").to_s
      end

      # Execute the command
      #
      # @api public
      def execute
        puts "OPTS: #{options}" if options['debug']

        coc_opt  = options['coc'] ? '--coc' : '--no-coc'
        ext_opt  = options['ext'] ? '--ext' : '--no-ext'
        test_opt = options['test']
        command = [
          "bundle gem #{target_path}",
          '--no-mit',
          '--no-exe',
          coc_opt,
          ext_opt,
          "-t #{test_opt}"
        ].join(' ')

        out, = run(command)

        if !options['no-color']
          out = out.gsub(/^(\s+)(create)/, '\1' + @pastel.green('\2'))
                   .gsub(/^(\s+)(identical)/, '\1' + @pastel.yellow('\2'))
        end

        @templater.add_mapping('lib/newcli/cli.rb.tt',
                               "lib/#{namespaced_path}/cli.rb")
        @templater.add_mapping('exe/newcli.tt', "exe/#{app_name}")

        license = options['license'] == 'none' ? false : options['license']
        if license
          @templater.add_mapping("#{license}_LICENSE.txt.tt", 'LICENSE.txt')
          add_license_to_gemspec(license)
        end

        puts out

        add_tty_libs_to_gemspec
        @templater.generate(template_options, color_option)
      end

      private

      # Add license definition to gemspec
      #
      # @api private
      def add_license_to_gemspec(license)
        gemspec = TTY::Gemspec.new
        gemspec.read(gemspec_path)
        license_regex = /(^\s*#{gemspec.var_name}\.license\s*=\s*).*/

        if gemspec.content =~ license_regex
          gemspec.content.gsub!(liecense_regex,
                                "\\1\"#{licenses[license][:name]}\"")
        else
          gem_license = ' ' * gemspec.pre_indent
          gem_license << "#{gemspec.var_name}.license"
          gem_license << ' ' * gemspec.post_indent
          gem_license << "= \"#{licenses[license][:name]}\""
          gemspec.content.gsub!(/(^\s*#{gemspec.var_name}\.name\s*=\s*.*$)/,
                                "\\1\n#{gem_license}")
        end
        gemspec.write(gemspec_path)
      end

      def add_tty_libs_to_gemspec
        gemspec = TTY::Gemspec.new
        gemspec.read(gemspec_path)
        dependencies = ['']
        plugins = TTY::Plugins.new
        plugins.load_from(GEMSPEC_PATH, /^tty-(.*)|pastel/)

        plugins.each do |plugin|
          dependency = ' ' * gemspec.pre_indent
          dependency << "#{gemspec.var_name}.add_dependency "
          dependency << "\"#{plugin.gem.name}\", "
          dependency << "\"#{plugin.gem.requirements_list.join(', ')}\""
          dependencies << dependency.dup
        end
        dependencies << '' # add extra line
        content = dependencies.join("\n")

        within_root_path do
          path = app_path.join(gemspec_name)
          inject_into_file(path, content,
            { before: /^\s*spec\.add_development_dependency\s*"bundler.*$/ }
            .merge(color_option))
        end
      end
    end # New
  end # Commands
end # TTY
