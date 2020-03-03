# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "vcr_assistant"
  spec.version       = "1.0.1"
  spec.authors       = ["Pat Allan"]
  spec.email         = ["pat@freelancing-gods.com"]

  spec.summary       = %q{Manages VCR cassettes and set-up logic.}
  spec.homepage      = "https://github.com/pat/vcr_assistant"

  spec.files         = `git ls-files -z`.split("\x0").reject { |file|
    file.match(%r{^(test|spec|features)/})
  }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |file| File.basename(file) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "vcr", ">= 3.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   "~> 3.0"
end
