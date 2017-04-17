# encoding: utf-8

require 'pastel'
require 'pathname'
require 'ostruct'

require_relative '../cmd'
require_relative '../plugins'
require 'open3'

module TTY
  module Commands
    # The `new` command
    # @api private
    class New < Cmd
      GEMSPEC_PATH = ::File.expand_path("#{::File.dirname(__FILE__)}/../../../tty.gemspec")
      # @api private
      attr_reader :app_name

      attr_reader :app_path

      # @api private
      attr_reader :options

      # @api private
      attr_reader :target_path

      attr_reader :root_path

      attr_reader :templates

      def initialize(app_path, options)
        @root_path = Pathname.pwd
        @app_path = resolve_path(app_path)
        @app_name = resolve_name(app_path)
        @options  = options
        @pastel   = Pastel.new

        @target_path = @root_path.join(@app_path)
        @templates   = {}
      end

      # Extract a relative path for the app
      #
      # @api private
      def resolve_path(path)
        project_path = Pathname.new(path)
        return project_path if project_path.relative?
        project_path.relative_path_from(root_path)
      end

      def resolve_name(name)
        Pathname.pwd.join(name).basename.to_s
      end

      def template_source_path
        path = ::File.join(::File.dirname(__FILE__), '..', 'templates/new')
        ::File.expand_path(path)
      end

      def within_root_path(&block)
        Dir.chdir(root_path, &block)
      end

      def git_exist?
        exec_exist?('git')
      end

      def git_author
        git_exist? ? `git config user.name`.chomp : ''
      end

      def template_options
        opts = OpenStruct.new
        opts[:app_name] = app_name,
        opts[:author]   = git_author.empty? ? 'TODO: Write your name' : git_author
        opts
      end

      def color_option
        options['no-color'] ? { color: false } : {}
      end

      def licenses
        @licenses ||= {
          'agplv3' => { name: 'AGPL-3.0',
                        desc: 'GNU Affero General Public License v3.0' },
          'apache' => { name: 'Apache-2.0', desc: 'Apache License 2.0' },
          'gplv2'  => { name: 'GPL-2.0',
                        desc: 'GNU General Public License v2.0' },
          'gplv3'  => { name: 'GPL-3.0',
                        desc: 'GNU General Public License v3.0' },
          'lgplv3' => { name: 'LGPL-3.0',
                        desc: 'GNU Lesser General Public License v3.0' },
          'mit'    => { name: 'MIT', desc: 'MIT License' },
          'mplv2'  => { name: 'MPL-2.0', desc: 'Mozilla Public License 2.0' }
        }
      end

      def add_mapping(source, target)
        @templates[source] = target
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
        test_opt = options['test']
        command = [
          "bundle gem #{target_path}",
          '--no-mit',
          '--no-exe',
          coc_opt,
          "-t #{test_opt}"
        ].join(' ')

        out, = run(command)

        if !options['no-color']
          out = out.gsub(/^(\s+)(create)/, '\1' + @pastel.green('\2'))
                   .gsub(/^(\s+)(identical)/, '\1' + @pastel.yellow('\2'))
        end

        license = options['license'] == 'none' ? false : options['license']
        if license
          add_mapping("#{license}_LICENSE.txt.erb", 'LICENSE.txt')
          add_license_to_gemspec(license)
        end

        puts out

        add_tty_libs_to_gemspec

        templates.each do |src, dst|
          source = ::File.join(template_source_path, src)
          destination = ::File.join(app_path, dst)
          next unless ::File.exist?(source)
          within_root_path do
            copy_file(source, destination,
                      { context: template_options }.merge(color_option))
          end
        end
      end

      Gemspec = Struct.new(:content, :var_name, :pre_indent, :post_indent) do
        def read(path)
          self.content = ::File.read(path)
          self.var_name = content.match(/(\w+)\.name/)[1]
          matches = content.match(/^(\s*)#{var_name}\.name(\s*)=.*$/)
          self.pre_indent  = matches[1].size
          self.post_indent = matches[2].size - ('license'.size - 'name'.size)
        end

        def write(path)
          ::File.write(path, content)
        end
      end

      def add_license_to_gemspec(license)
        gemspec = Gemspec.new
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
        gemspec = Gemspec.new
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
          path = Pathname.new(app_path).join("#{app_name}.gemspec").to_s
          inject_into_file(path, content,
            { before: /^\s*spec\.add_development_dependency\s*"bundler.*$/ }
            .merge(color_option))
        end
      end
    end # New
  end # Commands
end # TTY
