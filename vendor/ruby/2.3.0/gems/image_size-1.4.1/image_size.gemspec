# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = 'image_size'
  s.version     = '1.4.1'
  s.summary     = %q{Measure image size using pure Ruby}
  s.description = %q{Measure following file dimensions: bmp, cur, gif, jpeg, ico, pbm, pcx, pgm, png, ppm, psd, swf, tiff, xbm, xpm}
  s.homepage    = "http://github.com/toy/#{s.name}"
  s.authors     = ['Keisuke Minami', 'Ivan Kuchin']
  s.license     = 'MIT'

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w[lib]

  s.add_development_dependency 'rspec', '~> 3.0'
end
