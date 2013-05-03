# -*- encoding: utf-8 -*-

require File.expand_path('../lib/wocket/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "wocket"
  gem.version       = Wocket::VERSION
  gem.summary       = %q{Simple WebSocket server built on top of Celluloid::IO}
  gem.description   = %q{Simple WebSocket server built on top of Celluloid::IO}
  gem.license       = "MIT"
  gem.authors       = ["Brady Love"]
  gem.email         = "love.brady@gmail.com"
  gem.homepage      = "https://github.com/bradylove/wocket#readme"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']


  gem.add_runtime_dependency 'celluloid-io'
  gem.add_runtime_dependency 'websocket'

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-inotify'
  gem.add_development_dependency 'pry'
end
