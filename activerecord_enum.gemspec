# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "activerecord_enum/version"

Gem::Specification.new do |s|
  s.name        = "activerecord_enum"
  s.version     = ActiverecordEnum::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Young"]
  s.email       = ["ian.greenleaf+github@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Enum data types for ActiveRecord}
  s.description = %q{Adds the ENUM data type natively to ActiveRecord.}

  s.rubyforge_project = "activerecord_enum"

  s.add_dependency "activerecord", "~> 3.0.9"
  s.add_development_dependency "rake"
  s.add_development_dependency "bundler"
  s.add_development_dependency "mysql2", "~> 0.2.0"
  s.add_development_dependency "rspec", "~> 2.6.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
