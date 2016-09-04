# -*- encoding: utf-8 -*-
# stub: POpen4 0.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "POpen4"
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["John-Mason P. Shackelford"]
  s.date = "2009-11-16"
  s.description = ""
  s.email = "john-mason@shackelford.org"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/pka/popen4"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubygems_version = "2.5.1"
  s.summary = "Open4 cross-platform"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<Platform>, [">= 0.4.0"])
      s.add_runtime_dependency(%q<open4>, [">= 0"])
    else
      s.add_dependency(%q<Platform>, [">= 0.4.0"])
      s.add_dependency(%q<open4>, [">= 0"])
    end
  else
    s.add_dependency(%q<Platform>, [">= 0.4.0"])
    s.add_dependency(%q<open4>, [">= 0"])
  end
end
