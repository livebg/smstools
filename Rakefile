require 'bundler/gem_tasks'

task :test do
  test_files = Dir[File.expand_path('../spec/**/*_spec.rb', __FILE__)]
  command    = "ruby -Ispec #{test_files.join ' '}"

  puts "Running #{command}"
  system command
end

task default: :test
