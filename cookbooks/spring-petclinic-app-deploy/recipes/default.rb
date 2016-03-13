#
# Cookbook Name:: spring-petclinic-app-deploy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

app_data = data_bag_item("spring_petclinic_new","app_details")

node.default['java']['jdk_version'] = "7"

# Install curl - required by kitchen for testing
package 'curl' do
  action :install
end

# Install Java
include_recipe 'java'

#node.default['tomcat']['base_version'] = 7

# Install Tomcat
include_recipe 'tomcat'

# Deploy app
application 'petclinic' do
  path '/var/www/petclinic'
  repository app_data['artifact_location']
  revision app_data['version']
  scm_provider Chef::Provider::RemoteFile::Deploy

  java_webapp
  #tomcat
end

tomcat_webapps_dir = node['tomcat']['webapp_dir']
tomcat_service_name = node['tomcat']['base_instance']

service 'tomcat' do
  action :nothing
  service_name tomcat_service_name
end

# # Stop Tomcat
# service tomcat_service_name do
#   action :stop
# end

# # Clean webapps folder
# directory "#{tomcat_webapps_dir}/petclinic" do
#   action :delete
#   recursive true
# end

# # Download war to tomcat webapps
# remote_file "#{tomcat_webapps_dir}/petclinic.war.zip" do
#   owner 'root'
#   group 'root'
#   mode '0775'
#   source app_data['artifact_location']
#   notifies :run, 'execute[rename_petclinic.war.zip]'
# end

# execute 'rename_petclinic.war.zip' do
#   command 'mv -f petclinic.war.zip petclinic.war'
#   cwd tomcat_webapps_dir
#   action :nothing
#   notifies :restart, "service[#{tomcat_service_name}]"
# end

