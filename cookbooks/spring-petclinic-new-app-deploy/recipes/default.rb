#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

app_data = data_bag_item('spring-petclinic', 'app_details')

node.default['java']['jdk_version'] = '7'

# Install Java
include_recipe 'java'

package 'curl' do
  action :install
end

tomcat_service_name = node['tomcat']['base_instance']
tomcat_base_dir = "/opt/tomcat_#{tomcat_service_name}"

# Install Tomcat
tomcat_install tomcat_service_name do
  version '8.0.36'
end

tomcat_service tomcat_service_name do
  action [:enable, :stop]
end

include_recipe 'spring-petclinic-new-app-deploy::tomcat_hardening'

# Clean webapps folder
directory "#{tomcat_base_dir}/webapps/#{tomcat_service_name}" do
  action :delete
  recursive true
end

# Download war to tomcat webapps
remote_file "#{tomcat_base_dir}/webapps/petclinic.war.zip" do
  owner 'root'
  group 'root'
  mode '0775'
  source app_data['artifact_location']
  notifies :run, 'execute[rename_petclinic.war.zip]'
end

execute 'rename_petclinic.war.zip' do
  command 'mv -f petclinic.war.zip petclinic.war'
  cwd "#{tomcat_base_dir}/webapps"
  action :nothing
  notifies :start, "tomcat_service[#{tomcat_service_name}]"
end
