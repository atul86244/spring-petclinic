#
# Cookbook Name:: build-cookbook
# Recipe:: syntax
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'delivery-truck::syntax'

log "Running Syntax Tests"

execute 'mvn compile' do
  command 'mvn compile'
  cwd node['delivery']['workspace']['repo']
  action :run
end
