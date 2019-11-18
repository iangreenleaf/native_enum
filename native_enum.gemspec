# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "native_enum/version"

Gem::Specification.new do |s|
  s.name        = "native_enum"
  s.version     = NativeEnum::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Young"]
  s.email       = ["dev@iangreenleaf.com"]
  s.homepage    = ""
  s.summary     = %q{Enum data types for ActiveRecord}
  s.description = %q{Adds the ENUM data type natively to ActiveRecord.}
  s.license = "MIT"

  s.rubyforge_project = "native_enum"

  s.add_dependency "activerecord", ">= 3.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "bundler"
  s.add_development_dependency "mysql2", ">= 0.3.11", "< 0.5"
  s.add_development_dependency "sqlite3", "~>1.3.4"
  s.add_development_dependency "rspec", "~> 3.1"
  s.add_development_dependency "appraisal"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
