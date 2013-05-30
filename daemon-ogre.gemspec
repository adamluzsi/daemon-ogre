# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "daemon-ogre"
  s.version = "1.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam.Luzsi"]
  s.date = "2013-05-30"
  s.description = "This gem is made for one purpose. Ruby meant to be for easy use, not hardcore coding! And in terms for this, ogre will aid you in the brute way, so you can relax... Are you need load a whole bunch of folders to your rack application ? do it! You want one nice hash for config constant from ymls all over your dirs? sure you can! you want have start/stop/status/restart/daemon/etc argument commands from terminal to control your application without any fuss? There you go! Are you need an easy way to do the classic way of daemonise your awsome app? there will be no problem at all, let the Ogre do the job :) so all you need is enjoy your code! Follow me on Github and send request if you have idea what can be usefull in creating your app :)   https://github.com/adamluzsi/daemon-ogre.git"
  s.email = "adamluzsi@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "README.rdoc"
  ]
  s.files = [
    ".idea/.name",
    ".idea/.rakeTasks",
    ".idea/daemon-ogre.iml",
    ".idea/encodings.xml",
    ".idea/misc.xml",
    ".idea/modules.xml",
    ".idea/scopes/scope_settings.xml",
    ".idea/vcs.xml",
    ".idea/workspace.xml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "daemon-ogre.gemspec",
    "lib/daemon-ogre.rb",
    "test/helper.rb",
    "test/test_daemon-ogre.rb",
    "test/var/daemon.stderr.log",
    "test/var/log/log_file_name",
    "test/var/pid/pid_file_name"
  ]
  s.homepage = "http://github.com/adamluzsi/daemon-ogre"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Let the Ogre Do the hard work"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<debugger>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
    else
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<debugger>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    end
  else
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<debugger>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
  end
end

