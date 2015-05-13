# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taxplorer/version'

Gem::Specification.new do |spec|
  spec.name          = "taxplorer"
  spec.version       = Taxplorer::VERSION
  spec.authors       = ["Seosamh Cahill"]
  spec.email         = ["seo.cahill@gmail.com"]
  spec.summary       = %q{XBRL taxonomy parser}
  spec.description   = %q{View Taxonomy stuff.}
  spec.homepage      = "https://github.com/seocahill/taxplorer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["taxplorer"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
