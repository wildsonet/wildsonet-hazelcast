lib = File.join(File.dirname(__FILE__), "lib")
$: << lib unless $:.include?(lib)

require "wildsonet-hazelcast-version"

Gem::Specification.new do |s|

  s.name = "wildsonet-hazelcast"
  s.version = Wildsonet::Hazelcast::VERSION
  s.authors = ["Marek Jelen"]
  s.summary = "Hazelcast integration"
  s.description = "Hazelcast integration and surrounding features."
  s.email = "marek@jelen.biz"
  s.homepage = "http://github.com/marekjelen/wildsonet-hazelcast"
  s.licenses = ["MIT"]

  s.platform = "java"
  s.required_rubygems_version = ">= 1.3.6"

  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]

  s.files = [
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "jars/hazelcast-all.jar",
    "lib/wildsonet-hazelcast.rb",
    "lib/wildsonet-hazelcast-version.rb",
    "wildsonet-hazelcast.gemspec"
  ]

  s.require_paths = ["lib"]

  s.test_files = [
  ]

end

