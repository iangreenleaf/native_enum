require 'bundler'
require 'yaml'
Bundler::GemHelper.install_tasks

DB_CONFIG = "spec/database.yml"
GEMFILES = "spec/Gemfile.rails_[0-9]_[0-9]"

require 'rake'
desc 'Default: run all unit tests.'
task :default => :"spec:all"

require 'active_record'

# For more info on DatabaseTasks, see:
# https://github.com/rails/rails/blob/v5.0.7/activerecord/lib/active_record/tasks/database_tasks.rb
namespace :db do
  task :load_config do
    db_configs = YAML.load_file('spec/database.yml')
    ActiveRecord::Tasks::DatabaseTasks.tap do |db_tasks|
      ActiveRecord::Base.configurations = db_configs
      db_tasks.database_configuration = db_configs
      db_tasks.db_dir = 'db'
      db_tasks.root = File.dirname(__FILE__)
    end
  end

  desc 'Prepare the databases.'
  task prepare: :load_config do
    unless File.exist? DB_CONFIG
      cp "#{DB_CONFIG}.tmpl", DB_CONFIG
    end

    ActiveRecord::Tasks::DatabaseTasks.tap do |db_tasks|
      db_tasks.create_current('mysql')
      db_tasks.create_current('sqlite')
    end
  end

  desc "Drop all databases created for testing"
  task drop_all: :load_config do
    ActiveRecord::Tasks::DatabaseTasks.drop_all
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
