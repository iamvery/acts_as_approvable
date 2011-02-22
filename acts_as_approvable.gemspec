# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "acts_as_approvable"
  s.summary = "Make an ActiveRecord model approvable."
  s.description = "Make an ActiveRecord model approvable."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version = "0.0.1"
end