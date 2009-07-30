require 'thinking_sphinx'
require 'thinking_sphinx/tasks'

namespace :radiant do
  namespace :extensions do
    namespace :sphinx_search do
      
      desc "Runs the migration of the Sphinx Search extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          SphinxSearchExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          SphinxSearchExtension.migrator.migrate
        end
      end
      
      desc "Turns off indexing for subsequent tasks"
      task :disable_deltas do
        ThinkingSphinx.deltas_enabled = false
      end

      desc "Copies public assets of the Sphinx Search to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from SphinxSearchExtension"
        Dir[SphinxSearchExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(SphinxSearchExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end

      desc 'Run specs with coverage'
      task :coverage do
        Spec::Rake::SpecTask.new('radiant:extensions:sphinx_search:coverage') do |t|
          t.spec_opts = ['--format profile', '--loadby mtime', '--reverse']
          t.spec_files = FileList['vendor/extensions/sphinx_search/spec/**/*_spec.rb']
          t.rcov = true
          t.rcov_opts = ['--exclude', 'gems,spec,/usr/lib/ruby,config,vendor/radiant', '--include-file', 'vendor/extensions/sphinx_search/app,vendor/extensions/sphinx_search/lib', '--sort', 'coverage']
          t.rcov_dir = 'coverage'
        end
      end

    end
  end
end