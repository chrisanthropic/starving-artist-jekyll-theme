# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "starving-artist-jekyll-theme"
  spec.version       = "0.2.7"
  spec.authors       = ["chrisanthropic"]
  spec.email         = ["ctarwater@gmail.com"]

  spec.summary       = "A mobile-friendly Jekyll theme for visual artists with custom layouts for: contact page, about page, blog, and pinterest-style gallery layout."
  spec.homepage      = "https://github.com/chrisanthropic/starving-artist-jekyll-theme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(_(includes|layouts|sass)/|(LICENSE|README)((\.(txt|md|markdown)|$)))}i)
  end
  
  spec.add_development_dependency "jekyll", "~> 3.2"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "12.3.3"
end


