# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "informant/version"

Gem::Specification.new do |s|
  s.name        = "informant"
  s.version     = Informant::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "informant"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "thin", "~> 1.3.1"
  s.add_dependency "sinatra", "~> 1.3.2"
  s.add_dependency "sinatra-synchrony", "~> 0.1.1"

  s.add_development_dependency "rspec", "2.9.0"
  s.add_development_dependency "rake_commit"
end
