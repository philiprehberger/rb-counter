# frozen_string_literal: true

require_relative 'lib/philiprehberger/counter/version'

Gem::Specification.new do |spec|
  spec.name          = 'philiprehberger-counter'
  spec.version       = Philiprehberger::Counter::VERSION
  spec.authors       = ['Philip Rehberger']
  spec.email         = ['me@philiprehberger.com']

  spec.summary       = 'Frequency counter with most-common, merge, and percentage operations'
  spec.description   = 'Count element frequencies from any enumerable with most-common and least-common queries, ' \
                       'merge and subtract operations, percentage calculations, and Enumerable support.'
  spec.homepage      = 'https://github.com/philiprehberger/rb-counter'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']       = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
