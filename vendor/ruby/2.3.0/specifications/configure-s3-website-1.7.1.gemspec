# -*- encoding: utf-8 -*-
# stub: configure-s3-website 1.7.1 ruby lib

Gem::Specification.new do |s|
  s.name = "configure-s3-website"
  s.version = "1.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Lauri Lehmijoki"]
  s.date = "2015-02-19"
  s.email = "lauri.lehmijoki@iki.fi"
  s.executables = ["configure-s3-website"]
  s.files = ["bin/configure-s3-website"]
  s.homepage = "https://github.com/laurilehmijoki/configure-s3-website"
  s.rubygems_version = "2.5.1"
  s.summary = "Configure your AWS S3 bucket to function as a web site"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<deep_merge>, ["= 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.10.0"])
      s.add_development_dependency(%q<rspec-expectations>, ["~> 2.10.0"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.2.0"])
      s.add_development_dependency(%q<aruba>, ["~> 0.4.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.0"])
      s.add_development_dependency(%q<vcr>, ["~> 2.3.0"])
      s.add_development_dependency(%q<webmock>, ["~> 1.8.0"])
      s.add_development_dependency(%q<json>, ["~> 1.7.7"])
    else
      s.add_dependency(%q<deep_merge>, ["= 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.10.0"])
      s.add_dependency(%q<rspec-expectations>, ["~> 2.10.0"])
      s.add_dependency(%q<cucumber>, ["~> 1.2.0"])
      s.add_dependency(%q<aruba>, ["~> 0.4.0"])
      s.add_dependency(%q<rake>, ["~> 0.9.0"])
      s.add_dependency(%q<vcr>, ["~> 2.3.0"])
      s.add_dependency(%q<webmock>, ["~> 1.8.0"])
      s.add_dependency(%q<json>, ["~> 1.7.7"])
    end
  else
    s.add_dependency(%q<deep_merge>, ["= 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.10.0"])
    s.add_dependency(%q<rspec-expectations>, ["~> 2.10.0"])
    s.add_dependency(%q<cucumber>, ["~> 1.2.0"])
    s.add_dependency(%q<aruba>, ["~> 0.4.0"])
    s.add_dependency(%q<rake>, ["~> 0.9.0"])
    s.add_dependency(%q<vcr>, ["~> 2.3.0"])
    s.add_dependency(%q<webmock>, ["~> 1.8.0"])
    s.add_dependency(%q<json>, ["~> 1.7.7"])
  end
end
