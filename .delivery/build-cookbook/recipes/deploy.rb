#
# Cookbook Name:: build-cookbook
# Recipe:: deploy
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# This search assumes that your deploy cookbook's name matches with the name of your app.
# e.g. spring-petclinic-app-deploy::default where spring-petclinic is the app name. 
# The deploy cookbook should be added to the run_list of the infra nodes in each chef environment
# and the infra nodes should be searchable using the search filter "recipes:<deploy_cookbookname>*"
# You can modify this search if required.

search_query = "recipes:#{node['delivery']['change']['project']}* AND chef_environment:#{delivery_environment} " 

my_nodes = delivery_chef_server_search(:node, search_query)
 
my_nodes.map!(&:name)

delivery_push_job "deploy_#{node['delivery']['change']['project']}" do
  command 'chef-client'
  nodes my_nodes
end
