#
# Cookbook Name:: build-cookbook
# Recipe:: lint
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'delivery-truck::lint'

log "Executing Lint Tests"

execute 'execute lint test' do
  command "./run.sh pmd -d #{node['delivery']['workspace']['repo']}/src/main/java/ -f text -R rulesets/java/basic.xml -version 1.7 -language java"
  cwd "#{node['build-cookbook']['pmd']['path']}/pmd-bin-5.1.0/bin/"
  action :run
end
