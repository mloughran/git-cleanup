require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "git-cleanup"
    gem.summary = %Q{Command line tool for interactively cleaning up old git branches (remotely and locally)}
    gem.description = %Q{Command line tool for interactively cleaning up old git branches (remotely and locally)}
    gem.email = "me@mloughran.com"
    gem.homepage = "http://github.com/mloughran/git-cleanup"
    gem.authors = ["Martyn Loughran"]
    gem.add_dependency 'grit', '~> 2.2.0'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
