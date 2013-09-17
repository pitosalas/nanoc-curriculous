require 'pry'

require 'erb'
CONF_FILE_PATH = "config/config_curr.rb"
CONF_FILE_PATH_TEMPLATE = "rake/config_curr.erb"
RUN_CONF_PATH = "lib/runtime_config.rb"
RUN_CONF_PATH_TEMPLATE = "rake/runtime_conf.erb"

Rake::TaskManager.record_task_metadata = true

def verify_environment
	if File.exists?(CONF_FILE_PATH)
		require_relative "../"+CONF_FILE_PATH
	else
		abort "ERROR: Didn't find #{CONF_FILE_PATH}. Use rake conf:declare task to create it."
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
	puts "[Writing #{RUN_CONF_PATH}/curriculous_config.rb]"
	File.open(RUN_CONF_PATH_TEMPLATE) do |f|
		erb = ERB.new(f.read)
		File.open(RUN_CONF_PATH, 'w') do |f|
			f.write erb.result(binding)
		end
	end
end

def blank? var
	var.nil? || var.length == 0
end

def config_ok?
	!blank?(AWS_BUCKET) && !blank?(TOPICS_DIR)
end

def show_help
	Rake::Task.tasks.each do |t|
		puts "\n    #{t.name} - #{t.full_comment}"
	end
end
