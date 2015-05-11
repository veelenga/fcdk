# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fcdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'fcdk'
  spec.version       = Fcdk::VERSION
  spec.authors       = ['veelenga']
  spec.email         = ['velenhaupt@gmail.com']
  spec.summary       = 'FC Dynamo Kyiv unofficial application.'
  spec.description   = <<-DESC
    Provides FC Dynamo's Kyiv season schedule, match results, tournament list etc.
    Do not miss next match with fcdk gem!
  DESC
  spec.homepage      = 'https://github.com/veelenga/fcdk'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^spec\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
