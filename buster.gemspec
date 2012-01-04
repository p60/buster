# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "buster/version"

Gem::Specification.new do |s|
  s.name        = "buster"
  s.version     = Buster::VERSION
  s.authors     = ["Jason Staten"]
  s.email       = ["jstaten07@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Service Bus}
  s.description = %q{Service Bus}

  s.rubyforge_project = "buster"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "ffi-rzmq"
  s.add_runtime_dependency "msgpack"
end
