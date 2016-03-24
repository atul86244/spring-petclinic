#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

app_data = data_bag_item('spring-petclinic-new', 'app_details')

node.default['java']['jdk_version'] = '7'

# Install Java
include_recipe 'java'

# Install Tomcat
include_recipe 'tomcat'

# Install curl - Required for testing using kitchen
execute 'apt-get update' do
  command 'apt-get update'
  action :run
end

package 'curl' do
  action :install
end

tomcat_webapps_dir = node['tomcat']['webapp_dir']
tomcat_service_name = node['tomcat']['base_instance']

# Stop Tomcat
service tomcat_service_name do
  action :stop
end

# Clean webapps folder
directory "#{tomcat_webapps_dir}/petclinic" do
  action :delete
  recursive true
end

# Download war to tomcat webapps
remote_file "#{tomcat_webapps_dir}/petclinic.war.zip" do
  owner 'root'
  group 'root'
  mode '0775'
  source app_data['artifact_location']
  notifies :run, 'execute[rename_petclinic.war.zip]'
end

execute 'rename_petclinic.war.zip' do
  command 'mv -f petclinic.war.zip petclinic.war'
  cwd tomcat_webapps_dir
  action :nothing
  notifies :restart, "service[#{tomcat_service_name}]"
end
