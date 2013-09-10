#!/usr/bin/env ruby

unless File.basename($0) == 'rake'
  system("rake -f #{__FILE__} #{ARGV.join(' ')}")
  exit
end

# Rakefile can continue here as normal
task :hello do
  puts "Hello world"
end