# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|

  spec.name           = "daemon-ogre"
  spec.version        = File.open(File.join(File.dirname(__FILE__),"VERSION")).read.split("\n")[0].chomp.gsub(' ','')
  spec.authors        = ["Adam Luzsi"]
  spec.email          = ["adamluzsi@gmail.com"]
  spec.homepage       = "http://github.com/adamluzsi/daemon-ogre"

  spec.description    = "Simple to use app ARGV based daemonizer"
  spec.summary        = "Simple to use app ARGV based daemonizer"

  spec.files          = `git ls-files`.split($/)
  spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ["lib"]

  spec.add_dependency "argv",">= 2.1.0"
  spec.add_dependency "tmp",">= 2.0.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

end

