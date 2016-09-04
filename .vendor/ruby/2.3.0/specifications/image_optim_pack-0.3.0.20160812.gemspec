# -*- encoding: utf-8 -*-
# stub: image_optim_pack 0.3.0.20160812 ruby lib

Gem::Specification.new do |s|
  s.name = "image_optim_pack"
  s.version = "0.3.0.20160812"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ivan Kuchin"]
  s.date = "2016-08-12"
  s.homepage = "http://github.com/toy/image_optim_pack"
  s.licenses = ["MIT"]
  s.rubyforge_project = "image_optim_pack"
  s.rubygems_version = "2.5.1"
  s.summary = "Precompiled binaries for image_optim: advpng, gifsicle, jhead, jpeg-recompress, jpegoptim, jpegtran, optipng, pngcrush, pngquant"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<image_optim>, ["~> 0.19"])
      s.add_runtime_dependency(%q<fspath>, ["< 4", ">= 2.1"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
    else
      s.add_dependency(%q<image_optim>, ["~> 0.19"])
      s.add_dependency(%q<fspath>, ["< 4", ">= 2.1"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<image_optim>, ["~> 0.19"])
    s.add_dependency(%q<fspath>, ["< 4", ">= 2.1"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
  end
end
