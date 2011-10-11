require "bundler/gem_tasks"
require 'rake/testtask'

desc "Default Task"
task :default => [ :test ]

# Run the unit tests
Rake::TestTask.new { |t|
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
}

