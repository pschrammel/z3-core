# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "z3/core"

Gem::Specification.new do |s|
  s.name        = "z3-core"
  s.version     = Z3::Core::VERSION
  s.authors     = ["Peter Schrammel"]
  s.email       = ["peter.schrammel@gmx.de"]
  s.homepage    = ""
  s.summary     = %q{Do you want to write a S3 compliant server? This gem could help you.}
  s.description = %q{Z3 encapsulates most of the request handling, signing, error classes .... That you need to build an Amazon S3 compliant server.}

  s.rubyforge_project = "z3-core"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec","~>2.9"
  s.add_runtime_dependency "rack","~>1.4"
end
