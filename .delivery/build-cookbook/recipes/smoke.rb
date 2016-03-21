#
# Cookbook Name:: build-cookbook
# Recipe:: smoke
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

log "Running Smoke Tests"

# Copy inspec test script to build node
cookbook_file '/tmp/smoke_test.rb' do
  source 'smoke_test.rb'
  mode '0775'
end

with_server_config do

	# Search to get nodes
	search_query = "recipes:#{node['delivery']['change']['project']}* AND chef_environment:#{delivery_environment}"
	nodes = search("node", "#{search_query}")
	ssh_user = node['build-cookbook']['ssh_user']
	ssh_key = node['build-cookbook']['ssh_key_path']

	nodes.each do | infra_node |
		ip = infra_node['cloud']['public_ipv4']
		# Execute inspec 
		execute 'execute_inspec' do
		   command "/opt/chefdk/embedded/bin/inspec exec /tmp/smoke_test.rb -t ssh://#{ssh_user}@#{ip} -i #{ssh_key}"
		   action :run
		end
	end
end
