# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pay_simple/version'

Gem::Specification.new do |spec|
  spec.name          = "pay_simple"
  spec.version       = PaySimple::VERSION
  spec.authors       = ["Brian Samson"]
  spec.email         = ["brian@briansamson.com.com"]
  spec.summary       = %q{Integrate with the payment processing API from paysimple.com }
  spec.homepage      = "https://github.com/tenforwardconsulting/pay_simple"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  
  spec.add_runtime_dependency "httparty"
end
