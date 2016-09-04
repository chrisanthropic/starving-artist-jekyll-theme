# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = 'fspath'
  s.version     = '3.0.1'
  s.summary     = %q{Better than Pathname}
  s.homepage    = "http://github.com/toy/#{s.name}"
  s.authors     = ['Ivan Kuchin']
  s.license     = 'MIT'

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w[lib]

  s.add_development_dependency 'rspec', '~> 3.0'
  if RUBY_VERSION >= '2.0'
    s.add_development_dependency 'rubocop', '~> 0.28'
  end
end
