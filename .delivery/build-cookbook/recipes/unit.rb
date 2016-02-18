#
# Cookbook Name:: build-cookbook
# Recipe:: unit
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

log "Running Unit Tests"

execute 'mvn test' do
  command 'mvn test'
  cwd node['delivery']['workspace']['repo']
  action :run
end
