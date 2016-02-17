#
# Cookbook Name:: build-cookbook
# Recipe:: quality
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

log "Running Quality Tests"

execute 'mvn findbugs:check' do
  command 'mvn findbugs:check'
  cwd node['delivery']['workspace']['repo']
  action :run
end
