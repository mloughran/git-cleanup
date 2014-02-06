# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "git-cleanup/version"

Gem::Specification.new do |s|
  s.name        = "git-cleanup"
  s.version     = GitCleanup::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Martyn Loughran"]
  s.email       = ["me@mloughran.com"]
  s.homepage    = "http://mloughran.github.com/git-cleanup/"
  s.summary     = %q{A simple interactive command line tool to help you cleanup your git branch detritus}
  s.description = %q{A simple interactive command line tool to help you cleanup your git branch detritus}
  
  s.add_dependency 'grit', '~> 2.5.0'
  s.add_dependency 'formatador', '~> 0.2.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
