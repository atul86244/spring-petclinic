#
# Cookbook Name:: build-cookbook
# Recipe:: functional
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

search_query = "recipes:#{node['delivery']['change']['project']}* AND chef_environment:#{delivery_environment} " 

my_nodes = delivery_chef_server_search(:node, search_query)
 
my_nodes.map!(&:name)

delivery_push_job "deploy_#{node['delivery']['change']['project']}" do
  command 'tomcat-compliance-scan'
  nodes my_nodes
end
