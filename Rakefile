require "bundler"
Bundler::GemHelper.install_tasks

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
