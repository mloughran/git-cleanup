# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "git-cleanup/version"

Gem::Specification.new do |s|
  s.name        = "git-cleanup"
  s.version     = GitCleanup::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Martyn Loughran"]
  s.email       = ["me@mloughran.com"]
  s.homepage    = "http://github.com/mloughran/git-cleanup"
  s.summary     = %q{Command line tool for interactively cleaning up old git branches (remotely and locally)}
  s.description = %q{Command line tool for interactively cleaning up old git branches (remotely and locally)}
  
  s.add_dependency 'grit', '~> 2.2.0'
  s.add_dependency 'formatador', '~> 0.2.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
