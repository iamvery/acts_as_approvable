$:.unshift File.expand_path('../lib', __FILE__)
require 'acts_as_approvable/version'

Gem::Specification.new do |s|
  s.name = "acts_as_approvable"
  s.version = ActsAsApprovable::Version::STRING
  s.summary = "Make an ActiveRecord model approvable."
  s.description = s.summary
  s.homepage = 'https://github.com/iamvery/acts_as_approvable'
  s.authors = ['Jay Hayes', 'Christoph Lupprich']
  
  s.files = Dir["lib/**/*"] + ["LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir['spec/**/*']
  
  s.add_dependency 'rails', '~> 3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.7'
  s.add_development_dependency 'shoulda', '~> 2.11'
end
