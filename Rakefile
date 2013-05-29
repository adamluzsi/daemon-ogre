# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "daemon-ogre"
  gem.homepage = "http://github.com/adamluzsi/daemon-ogre"
  gem.license = "MIT"
  gem.summary = %Q{Let the Ogre Do the hard work}
  gem.description = %Q{This gem is made for one purpose. Ruby meant to be for easy use, not hard code coding! And in terms for this, ogre will aid you in the brute way... you need load a whole bunch of folders to your rack application ? do it! you want one nice hash for config constant? sure you can! you want have start/stop/status/restart/etc argument commands from terminal to see does your app(s) running or not ? there you go! You need an easy way to do the classic way of daemonise your awsome app? there will be no problem :) so all you need is enjoy your code!}
  gem.email = "adam.luzsi@@ppt-consulting.net"
  gem.authors = ["adam.luzsi"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

#require 'rcov/rcovtask'
#Rcov::RcovTask.new do |test|
#  test.libs << 'test'
#  test.pattern = 'test/**/test_*.rb'
#  test.verbose = true
#  test.rcov_opts << '--exclude "gems/*"'
#end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "daemon-ogre #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
