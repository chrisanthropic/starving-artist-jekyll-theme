# -*- encoding: utf-8 -*-
# stub: jekyll-assets 2.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-assets"
  s.version = "2.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jordon Bedwell", "Aleksey V Zapparov", "Zachary Bush"]
  s.date = "2016-04-15"
  s.description = "    A Jekyll plugin, that allows you to write javascript/css assets in\n    other languages such as CoffeeScript, Sass, Less and ERB, concatenate\n    them, respecting dependencies, minify and many more.\n"
  s.email = ["jordon@envygeeks.io", "ixti@member.fsf.org", "zach@zmbush.com"]
  s.homepage = "http://github.com/jekyll/jekyll-assets/"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Assets for Jekyll"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sprockets>, ["~> 3.3"])
      s.add_runtime_dependency(%q<sprockets-helpers>, ["~> 1.2"])
      s.add_runtime_dependency(%q<fastimage>, ["~> 1.8"])
      s.add_runtime_dependency(%q<jekyll>, ["~> 3.0"])
      s.add_runtime_dependency(%q<tilt>, ["~> 2.0"])
      s.add_development_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_development_dependency(%q<luna-rspec-formatters>, ["~> 3.3"])
      s.add_development_dependency(%q<rspec>, ["~> 3.3"])
    else
      s.add_dependency(%q<sprockets>, ["~> 3.3"])
      s.add_dependency(%q<sprockets-helpers>, ["~> 1.2"])
      s.add_dependency(%q<fastimage>, ["~> 1.8"])
      s.add_dependency(%q<jekyll>, ["~> 3.0"])
      s.add_dependency(%q<tilt>, ["~> 2.0"])
      s.add_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_dependency(%q<luna-rspec-formatters>, ["~> 3.3"])
      s.add_dependency(%q<rspec>, ["~> 3.3"])
    end
  else
    s.add_dependency(%q<sprockets>, ["~> 3.3"])
    s.add_dependency(%q<sprockets-helpers>, ["~> 1.2"])
    s.add_dependency(%q<fastimage>, ["~> 1.8"])
    s.add_dependency(%q<jekyll>, ["~> 3.0"])
    s.add_dependency(%q<tilt>, ["~> 2.0"])
    s.add_dependency(%q<nokogiri>, ["~> 1.6"])
    s.add_dependency(%q<luna-rspec-formatters>, ["~> 3.3"])
    s.add_dependency(%q<rspec>, ["~> 3.3"])
  end
end
