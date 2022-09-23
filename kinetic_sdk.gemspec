
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kinetic_sdk/version"

Gem::Specification.new do |spec|
  spec.name          = "kinetic_sdk"
  spec.version       = KineticSdk::VERSION
  spec.authors       = ["Kinetic Data"]
  spec.email         = ["support@kineticdata.com"]

  spec.summary       = %q{Ruby SDK for Kinetic Data application APIs}
  spec.homepage      = "https://github.com/kineticdata/kinetic-sdk-rb"

  spec.files         = Dir.glob("{bin,lib,gems,.yardoc-includes}/**/*") + %w(kinetic_sdk.gemspec .yardopts CHANGELOG.md GettingStarted.md README.md Rakefile)
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency "slugify", "1.0.7"
  spec.add_dependency "multipart-post", "2.0.0"
  spec.add_dependency "mime-types", ">= 3.3.1"

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", ">= 13.0.1"
  spec.add_development_dependency "yard", "~> 0.9.25"

  spec.metadata["yard.run"] = "yri"
end
