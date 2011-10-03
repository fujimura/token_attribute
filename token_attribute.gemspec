# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "token_attribute/version"

Gem::Specification.new do |s|
  s.name        = "token_attribute"
  s.version     = TokenAttribute::VERSION
  s.authors     = ["Fujimura Daisuke"]
  s.email       = ["me@fujimuradaisuke.com"]
  s.homepage    = "https://github.com/fujimura/token_attribute"
  s.summary     = %q{Small macro to generate unique random token attribute for ActiveRecord}
  s.description = %q{Small macro to generate unique random token attribute for ActiveRecord}

  # s.rubyforge_project = "token_attribute"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "activerecord"
  s.add_dependency "activesupport"
  s.add_development_dependency "contest"
  s.add_development_dependency "rr"
  s.add_development_dependency "ruby-debug19"
end
