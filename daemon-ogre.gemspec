# -*- encoding: utf-8 -*-

require File.expand_path(File.join(File.dirname(__FILE__),"files.rb"))

Gem::Specification.new do |spec|

  spec.name           = "daemon-ogre"

  spec.version        = File.open(File.join(File.dirname(__FILE__),"VERSION")).read.split("\n")[0].chomp.gsub(' ','')

  spec.authors        = ["Adam.Luzsi"]
  spec.email          = "adamluzsi@gmail.com"

  spec.description    = "Simple to use app ARGV based daemonizer"
  spec.summary        = %q{DSL for helping make file loads and configuration objects }

  spec.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "README.rdoc"
  ]

  spec.files          = SpecFiles
  spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ["lib"]

  spec.homepage = "http://github.com/adamluzsi/daemon-ogre"
  spec.licenses = ["MIT"]

end

