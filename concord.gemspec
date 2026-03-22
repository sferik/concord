# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'concord'
  s.version     = '0.1.6'
  s.authors     = ['Markus Schirp']
  s.email       = ['mbj@schirp-dso.com']
  s.homepage    = 'https://github.com/mbj/concord'
  s.summary     = 'Helper for object composition'
  s.license     = 'MIT'
  s.description = s.summary

  s.files         = Dir.glob('lib/**/*') + Dir.glob('sig/concord.rbs') + %w[LICENSE]
  s.require_paths = %w[lib]

  s.required_ruby_version = '>= 3.3'
  s.required_rubygems_version = '>= 3.1'

  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/Changelog.md",
    'homepage_uri' => s.homepage,
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => s.homepage
  }

  s.add_dependency('adamantium', '~> 0.2.0')
  s.add_dependency('equalizer',  '~> 1.0')
end
