include Rake::DSL

require "bundler"
Bundler::GemHelper.install_tasks

desc "Run tests"
task :test do
  system "ruby -Ilib -Itest -e 'ARGV.each { |f| load f }' test/zendesk/*"
end

task :default => :test

namespace :doc do
  require "yard"
  YARD::Rake::YardocTask.new do |t|
    t.files = ["lib/**/*.rb"]
    t.options = [
      "--protected",
      "--output-dir", "doc/yard",
      "--markup", "markdown"
    ]
  end
end
