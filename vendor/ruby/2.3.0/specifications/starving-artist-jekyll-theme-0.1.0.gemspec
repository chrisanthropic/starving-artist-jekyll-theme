# -*- encoding: utf-8 -*-
# stub: starving-artist-jekyll-theme 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "starving-artist-jekyll-theme"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["chrisanthropic"]
  s.date = "2016-09-04"
  s.email = ["ctarwater@gmail.com"]
  s.homepage = "https://github.com/chrisanthropic/starving-artist-jekyll-theme"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "A mobile-friendly Jekyll theme for visual artists with custom layouts for: contact page, about page, blog, and pinterest-style gallery layout."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jekyll>, ["~> 3.2"])
      s.add_development_dependency(%q<bundler>, ["~> 1.12"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
    else
      s.add_dependency(%q<jekyll>, ["~> 3.2"])
      s.add_dependency(%q<bundler>, ["~> 1.12"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<jekyll>, ["~> 3.2"])
    s.add_dependency(%q<bundler>, ["~> 1.12"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
  end
end
