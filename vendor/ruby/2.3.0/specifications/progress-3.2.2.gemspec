# -*- encoding: utf-8 -*-
# stub: progress 3.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "progress"
  s.version = "3.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ivan Kuchin"]
  s.date = "2016-07-27"
  s.homepage = "http://github.com/toy/progress"
  s.licenses = ["MIT"]
  s.rubyforge_project = "progress"
  s.rubygems_version = "2.5.1"
  s.summary = "Show progress of long running tasks"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 3.0"])
  end
end
