# -*- encoding: utf-8 -*-
# stub: s3_website 2.15.0 ruby lib

Gem::Specification.new do |s|
  s.name = "s3_website"
  s.version = "2.15.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Lauri Lehmijoki"]
  s.date = "2016-08-29"
  s.description = "\n    Sync website files, set redirects, use HTTP performance optimisations, deliver via\n    CloudFront.\n  "
  s.email = ["lauri.lehmijoki@iki.fi"]
  s.executables = ["s3_website"]
  s.files = ["bin/s3_website"]
  s.homepage = "https://github.com/laurilehmijoki/s3_website"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Manage your S3 website"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, ["~> 0.18"])
      s.add_runtime_dependency(%q<configure-s3-website>, ["= 1.7.1"])
      s.add_runtime_dependency(%q<colored>, ["= 1.2"])
      s.add_runtime_dependency(%q<dotenv>, ["~> 1.0"])
      s.add_development_dependency(%q<rake>, ["= 10.1.1"])
      s.add_development_dependency(%q<octokit>, ["= 3.1.0"])
    else
      s.add_dependency(%q<thor>, ["~> 0.18"])
      s.add_dependency(%q<configure-s3-website>, ["= 1.7.1"])
      s.add_dependency(%q<colored>, ["= 1.2"])
      s.add_dependency(%q<dotenv>, ["~> 1.0"])
      s.add_dependency(%q<rake>, ["= 10.1.1"])
      s.add_dependency(%q<octokit>, ["= 3.1.0"])
    end
  else
    s.add_dependency(%q<thor>, ["~> 0.18"])
    s.add_dependency(%q<configure-s3-website>, ["= 1.7.1"])
    s.add_dependency(%q<colored>, ["= 1.2"])
    s.add_dependency(%q<dotenv>, ["~> 1.0"])
    s.add_dependency(%q<rake>, ["= 10.1.1"])
    s.add_dependency(%q<octokit>, ["= 3.1.0"])
  end
end
