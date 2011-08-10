require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'
desc 'Default: run unit tests.'
task :default => :test

require 'rake/testtask'
desc 'Run the test suite.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
