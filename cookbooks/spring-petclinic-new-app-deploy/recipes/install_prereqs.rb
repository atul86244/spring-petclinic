#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: install_prereqs
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install Java
node.default['java']['jdk_version'] = '7'
include_recipe 'java'

# Install curl
package 'curl' do
  action :install
end
