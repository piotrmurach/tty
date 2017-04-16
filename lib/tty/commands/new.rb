# encoding: utf-8

require 'pastel'
require 'pathname'
require 'ostruct'

require_relative '../cmd'
require 'open3'

module TTY
  module Commands
    class New < Cmd
      # @api private
      attr_reader :app_name

      # @api private
      attr_reader :options

      # @api private
      attr_reader :target_path

      attr_reader :templates

      def initialize(app_path, options)
        @app_path = app_path
        @app_name = resolve_name(app_path)
        @options  = options
        @pastel   = Pastel.new

        @target_path = Pathname.pwd.join(@app_path)
        @templates   = {}
      end

      def resolve_name(name)
        Pathname.pwd.join(name).basename.to_s
      end

      def template_source_path
        path = ::File.join(::File.dirname(__FILE__), '..', 'templates/new')
        ::File.expand_path(path)
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
        # cli_name = ::File.basename(app_name)
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

        templates.each do |src, dst|
          source = ::File.join(template_source_path, src)
          destination = target_path.join(dst).to_s
          next unless ::File.exist?(source)
          copy_file(source, destination, context: template_options)
        end
      end

      def add_license_to_gemspec(license)
        gemspec = ::File.read(gemspec_path)
        gemspec_var_name = gemspec.match(/(\w+)\.name/)[1]
        matches = gemspec.match(/^(\s*)#{gemspec_var_name}\.name(\s*)=.*$/)
        gemspec_pre_indent  = matches[1].size
        gemspec_post_indent = matches[2].size - ('license'.size - 'name'.size)

        license_regex = /(^\s*#{gemspec_var_name}\.license\s*=\s*).*/
        if gemspec =~ license_regex
          gemspec.gsub!(liecense_regex, "\\1\"#{licenses[license][:name]}\"")
        else
          gem_license = ' ' * gemspec_pre_indent
          gem_license << "#{gemspec_var_name}.license"
          gem_license << ' ' * gemspec_post_indent
          gem_license << "= \"#{licenses[license][:name]}\""
          gemspec.gsub!(/(^\s*#{gemspec_var_name}\.name\s*=\s*.*$)/,
                        "\\1\n#{gem_license}")
        end
        ::File.write(gemspec_path, gemspec)
      end
    end # New
  end # Commands
end # TTY
