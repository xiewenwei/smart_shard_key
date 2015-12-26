# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smart_shard_key/version'

Gem::Specification.new do |spec|
  spec.name          = "smart_shard_key"
  spec.version       = SmartShardKey::VERSION
  spec.authors       = ["vincent"]
  spec.email         = ["xiewnewei@gmail.com"]

  spec.summary       = %q{smart_shard_key is a tiny tool for generating smart_id and extracting shard_key from Smart ID.}
  spec.description   = %q{Smart ID is good way for id of sharding db/table. It is a little big long and composed of timestamp, shard_id and sequence.Smart ID keeps order of ID and contains many information. smart_shard_key is a tiny tool for generating smart_id and extracting shard_key from Smart ID.}
  spec.homepage      = "https://github.com/xiewenwei/smart_shard_key"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "'https://git.boohee.cn'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
