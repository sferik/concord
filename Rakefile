# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yardstick/rake/verify'

# Override release task to skip gem push (handled by GitHub Actions with attestations)
Rake::Task['release'].clear
desc 'Build gem and create tag (gem push handled by CI)'
task release: %w[build release:guard_clean release:source_control_push]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/unit/**/*_spec.rb'
end

RuboCop::RakeTask.new

desc 'Run mutant mutation testing'
task :mutant do
  sh 'bundle exec mutant run --zombie'
end

Yardstick::Rake::Verify.new(:yardstick) do |verify|
  verify.threshold = 100
end

desc 'Run Steep type checking'
task :steep do
  sh 'bundle exec steep check'
end

task default: %i[spec rubocop mutant yardstick steep]
