# frozen_string_literal: true

require_relative "lib/rsv/version"

Gem::Specification.new do |spec|
  spec.name = "rsv"
  spec.version = Rsv::VERSION
  spec.authors = ["David Shaffer"]
  spec.email = ["dave.shaffer@gmail.com"]

  spec.summary = "Rows of String Values"
  spec.description = "A dependency-free implementation of the Rows of String Values specification."
  spec.homepage = "https://github.com/flanger001/rsv"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end