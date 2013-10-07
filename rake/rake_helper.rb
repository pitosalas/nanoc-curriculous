require 'pry'

require 'erb'
require 'rake/clean'

CONF_FILE_PATH = "config/config_curr.rb"
CONF_FILE_PATH_TEMPLATE = "rake/config_curr.erb"
RUN_CONF_PATH = "lib/runtime_config.rb"
RUN_CONF_PATH_TEMPLATE = "rake/runtime_conf.erb"

module RakeHelpers
Rake::TaskManager.record_task_metadata = true
#Rake.application.options.trace_rules = true

	def verify_environment
		if File.exists?(CONF_FILE_PATH)
			require_relative "../"+CONF_FILE_PATH
		else
			fail "ERROR: Didn't find #{CONF_FILE_PATH}. Use rake conf:declare task to create it."
		end
	end

	def write_config_file content_path
		puts "[Writing #{CONF_FILE_PATH} file for #{content_path}]"
		File.open(CONF_FILE_PATH_TEMPLATE) do |f|
			erb = ERB.new(f.read)
			File.open(CONF_FILE_PATH, 'w') do |f|
				f.write erb.result(binding)
			end
		end
	end

	def write_runtime_config
		puts "[Writing #{RUN_CONF_PATH}]"
		File.open(RUN_CONF_PATH_TEMPLATE) do |f|
			erb = ERB.new(f.read)
			File.open(RUN_CONF_PATH, 'w') do |f|
				f.write erb.result(binding)
			end
		end
	end

	def smart_copy_files (files, source_dir, dest_dir)
		files.each do |f|
			dest_f = f.sub(source_dir, dest_dir)
			mkdir_p dest_f.match(/(.*)\/.*/)[1]
			cp_r f, dest_f
		end
	end

	def prepare_cleanlist
		CLEAN.include("content/**/*", "config/config_curr.rb")
	end

	def content_master
		CONTENT_PATH
	end

	def topics_master
		TOPICS_PATH
	end

	def content_working
		pwd+'/'
	end

	def topics_working
		pwd+'/content/topics'
	end

	def blank? var
		var.nil? || var.length == 0
	end

	def config_ok?
		!blank?(AWS_BUCKET) && !blank?(TOPICS_PATH)
	end

	def show_help
		Rake::Task.tasks.each do |t|
			puts "\n    #{t.name} - #{t.full_comment}"
		end
	end
end
