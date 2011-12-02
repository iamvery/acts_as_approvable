$:.unshift File.expand_path('..', __FILE__)
require 'lib/acts_as_approvable/version'

Gem::Specification.new do |s|
  s.name = "acts_as_approvable"
  s.version = ActsAsApprovable::Version::STRING
  s.summary = "Make an ActiveRecord model approvable."
  s.description = s.summary
  s.homepage = 'https://github.com/iamvery/acts_as_approvable'
  s.authors = ['Jay Hayes', 'Christoph Lupprich']
  
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir['spec/**/*']
  
  s.add_dependency 'rails', '~> 3'
  s.add_development_dependency 'rake'
end