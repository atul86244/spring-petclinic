#
# Cookbook Name:: build-cookbook
# Recipe:: security
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
search_query = "(#{search_terms.join(' OR ')}) " \
                 "AND chef_environment:#{delivery_environment} " \
                 "AND #{deployment_search_query}"

  my_nodes = delivery_chef_server_search(:node, search_query)

  my_nodes.map!(&:name)

  delivery_push_job "deploy_#{node['delivery']['change']['project']}" do
    command 'chef-client -r "role[audit_tomcat]"'
    nodes my_nodes
  end