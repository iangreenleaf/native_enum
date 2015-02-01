require 'bundler'
require 'yaml'
Bundler::GemHelper.install_tasks

DB_CONFIG = "spec/database.yml"
GEMFILES = "spec/Gemfile.rails_[0-9]_[0-9]"

require 'rake'
desc 'Default: run all unit tests.'
task :default => :"spec:all"

namespace :db do
  desc 'Prepare the databases.'
  task :prepare do
    unless File.exist? DB_CONFIG
      cp "#{config_file}.tmpl", DB_CONFIG
    end
    #TODO would be nice to create the DBs here
  end
end

require "rspec/core/rake_task"
desc 'Run the test suite.'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.exclude_pattern = 'spec/**/vendor/*'
end

desc 'Run the test suite for all DBs.'
namespace :spec do
  task :all do
    db_config = YAML::load(IO.read(DB_CONFIG))
    db_config.each do |db,config|
      ENV["DB"] = db
      Rake::Task["spec"].reenable
      Rake::Task["spec"].invoke
    end
  end

  desc 'Run the test suite for all supported versions of rails and all DBs'
  task :rails_all do
    STDOUT.sync = true
    versions = Dir.glob(GEMFILES)
    versions.each do |gemfile|
      puts "Running specs for Gemfile: #{gemfile}"
      Bundler.with_clean_env do
        sh "bundle install --gemfile '#{gemfile}' --path 'vendor/#{File.extname(gemfile).slice(1..-1)}'"
        sh "BUNDLE_GEMFILE='#{gemfile}' bundle exec rake spec:all"
      end
    end
  end
end
