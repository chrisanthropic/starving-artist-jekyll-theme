# -*- encoding: utf-8 -*-
# stub: extras 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "extras"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jordon Bedwell"]
  s.date = "2016-04-07"
  s.description = "Add some neat little extras into your Ruby stuff."
  s.email = ["jordon@envygeeks.io"]
  s.homepage = "http://github.com/envygeeks/extras"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Add neat extras into your Ruby stuff."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<forwardable-extended>, ["~> 2.5"])
    else
      s.add_dependency(%q<forwardable-extended>, ["~> 2.5"])
    end
  else
    s.add_dependency(%q<forwardable-extended>, ["~> 2.5"])
  end
end
