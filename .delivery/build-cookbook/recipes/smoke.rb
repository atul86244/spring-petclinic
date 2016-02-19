#
# Cookbook Name:: build-cookbook
# Recipe:: smoke
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

log "Running Smoke Tests"

# Install inspec
chef_gem 'inspec'

# Copy inspec test script to build node
cookbook_file '/tmp/smoke_test.rb' do
  source 'smoke_test.rb'
  mode '0775'
end

# Chef_Delivery::ClientHelper.enter_client_mode_as_delivery
with_server_config do

	# Run a search to get nodes
	search_query = node['delivery']['config']['delivery-truck']['deploy']['search']
	nodes = search("node", "chef_environment:#{delivery_environment} AND #{search_query}")
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
