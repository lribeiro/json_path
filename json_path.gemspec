
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "json_path/version"

Gem::Specification.new do |spec|
  spec.name          = "json_path"
  spec.version       = JsonPath::VERSION
  spec.authors       = ["Luis Landeiro Ribeiro"]
  spec.email         = ["ribeiro.luis@gmail.com"]

  spec.summary       = %q{Ruby conversion of the Javascript JsonPath from goessner}
  spec.description   = %q{Ruby conversion of the Javascript JsonPath from http://goessner.net/articles/JsonPath/}
  spec.homepage      = "https://github.com/lribeiro/json_path"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
