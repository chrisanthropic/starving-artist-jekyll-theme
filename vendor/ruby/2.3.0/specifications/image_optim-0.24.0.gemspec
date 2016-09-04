# -*- encoding: utf-8 -*-
# stub: image_optim 0.24.0 ruby lib

Gem::Specification.new do |s|
  s.name = "image_optim"
  s.version = "0.24.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ivan Kuchin"]
  s.date = "2016-08-14"
  s.executables = ["image_optim"]
  s.files = ["bin/image_optim"]
  s.homepage = "http://github.com/toy/image_optim"
  s.licenses = ["MIT"]
  s.post_install_message = "Rails image assets optimization is extracted into image_optim_rails gem\nYou can safely remove `config.assets.image_optim = false` if you are not going to use that gem\n"
  s.rubyforge_project = "image_optim"
  s.rubygems_version = "2.5.1"
  s.summary = "Optimize (lossless compress, optionally lossy) images (jpeg, png, gif, svg) using external utilities (advpng, gifsicle, jhead, jpeg-recompress, jpegoptim, jpegrescan, jpegtran, optipng, pngcrush, pngout, pngquant, svgo)"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fspath>, ["~> 3.0"])
      s.add_runtime_dependency(%q<image_size>, ["~> 1.3"])
      s.add_runtime_dependency(%q<exifr>, [">= 1.2.2", "~> 1.2"])
      s.add_runtime_dependency(%q<progress>, [">= 3.0.1", "~> 3.0"])
      s.add_runtime_dependency(%q<in_threads>, ["~> 1.3"])
      s.add_development_dependency(%q<image_optim_pack>, [">= 0.2.2", "~> 0.2"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
    else
      s.add_dependency(%q<fspath>, ["~> 3.0"])
      s.add_dependency(%q<image_size>, ["~> 1.3"])
      s.add_dependency(%q<exifr>, [">= 1.2.2", "~> 1.2"])
      s.add_dependency(%q<progress>, [">= 3.0.1", "~> 3.0"])
      s.add_dependency(%q<in_threads>, ["~> 1.3"])
      s.add_dependency(%q<image_optim_pack>, [">= 0.2.2", "~> 0.2"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<fspath>, ["~> 3.0"])
    s.add_dependency(%q<image_size>, ["~> 1.3"])
    s.add_dependency(%q<exifr>, [">= 1.2.2", "~> 1.2"])
    s.add_dependency(%q<progress>, [">= 3.0.1", "~> 3.0"])
    s.add_dependency(%q<in_threads>, ["~> 1.3"])
    s.add_dependency(%q<image_optim_pack>, [">= 0.2.2", "~> 0.2"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
  end
end
