#
# Cookbook Name:: build-cookbook
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# All applications that need to be installed on the build servers should go here

include_recipe 'delivery-truck::default'

# Install JDK 7
node.default['java']['jdk_version'] = "7"
include_recipe 'java'

# Install Inspec
chef_gem 'inspec'

# Install unzip
package 'unzip' do
  action :install
end

# Install maven
package 'maven' do
  action :install
end

# Install JUnit
package 'junit' do
  action :install
end

# Install pmd
remote_file '/tmp/pmd.zip' do
  owner 'root'
  group 'root'
  mode '0777'
  source node['build-cookbook']['pmd']['download_url']
end

directory node['build-cookbook']['pmd']['path'] do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

execute 'unzip pmd' do
  command "unzip pmd.zip -d #{node['build-cookbook']['pmd']['path']}"
  cwd "/tmp"
  action :run
  not_if { Dir.exist?("#{node['build-cookbook']['pmd']['path']}/pmd-bin-5.1.0/bin/")}
end

