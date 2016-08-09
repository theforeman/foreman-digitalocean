require File.expand_path("../engine", File.dirname(__FILE__))
namespace :test do
  desc "Run the plugin unit test suite."
  task :digitalocean => ['db:test:prepare'] do
    test_task = Rake::TestTask.new('digitalocean_test_task') do |t|
      t.libs << ["test", "#{ForemanDigitalocean::Engine.root}/test"]
      t.test_files = [
        "#{ForemanDigitalocean::Engine.root}/test/**/*_test.rb"
      ]
      t.verbose = true
      t.warning = false
    end

    Rake::Task[test_task.name].invoke
  end
end

namespace :digitalocean do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_digitalocean) do |task|
        task.patterns = ["#{ForemanDigitalocean::Engine.root}/app/**/*.rb",
                         "#{ForemanDigitalocean::Engine.root}/lib/**/*.rb",
                         "#{ForemanDigitalocean::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts "Rubocop not loaded."
    end

    Rake::Task['rubocop_digitalocean'].invoke
  end
end

Rake::Task[:test].enhance do
  Rake::Task['test:digitalocean'].invoke
end

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task["jenkins:unit"].enhance do
    Rake::Task['test:digitalocean'].invoke
    Rake::Task['digitalocean:rubocop'].invoke
  end
end
