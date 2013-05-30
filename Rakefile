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
  gem.name = "daemon-ogre"
  gem.homepage = "http://github.com/adamluzsi/daemon-ogre"
  gem.license = "MIT"
  gem.summary = %Q{Let the Ogre Do the hard work}
  gem.description = %Q{This gem is made for one purpose. Ruby meant to be for easy use, not hardcore coding! And in terms for this, ogre will aid you in the brute way, so you can relax... Are you need load a whole bunch of folders to your rack application ? do it! You want one nice hash for config constant from ymls all over your dirs? sure you can! you want have start/stop/status/restart/daemon/etc argument commands from terminal to control your application without any fuss? There you go! Are you need an easy way to do the classic way of daemonise your awsome app? there will be no problem at all, let the Ogre do the job :) so all you need is enjoy your code! Follow me on Github and send request if you have idea what can be usefull in creating your app :)   https://github.com/adamluzsi/daemon-ogre.git}
  gem.email = "adamluzsi@gmail.com"
  gem.authors = ["Adam.Luzsi"]
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
