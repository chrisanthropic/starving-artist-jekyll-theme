# -*- encoding: utf-8 -*-
# stub: in_threads 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "in_threads"
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ivan Kuchin"]
  s.date = "2015-01-09"
  s.homepage = "http://github.com/toy/in_threads"
  s.licenses = ["MIT"]
  s.rubyforge_project = "in_threads"
  s.rubygems_version = "2.5.1"
  s.summary = "Execute ruby code in parallel"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-retry>, ["~> 0.3"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.26"])
    else
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<rspec-retry>, ["~> 0.3"])
      s.add_dependency(%q<rubocop>, ["~> 0.26"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<rspec-retry>, ["~> 0.3"])
    s.add_dependency(%q<rubocop>, ["~> 0.26"])
  end
end
