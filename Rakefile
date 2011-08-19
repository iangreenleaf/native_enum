require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'
desc 'Default: run unit tests.'
task :default => :spec

require "rspec/core/rake_task"
desc 'Run the test suite.'
RSpec::Core::RakeTask.new(:spec)
