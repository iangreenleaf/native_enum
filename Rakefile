require 'bundler'
Bundler::GemHelper.install_tasks

DB_CONFIG = "spec/database.yml"

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
RSpec::Core::RakeTask.new(:spec)

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
end
