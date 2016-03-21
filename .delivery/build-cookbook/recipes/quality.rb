#
# Cookbook Name:: build-cookbook
# Recipe:: quality
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'delivery-truck::quality'

log "Running Quality Tests"

execute 'mvn findbugs:check' do
  command 'mvn findbugs:check'
  cwd node['delivery']['workspace']['repo']
  action :run
end
