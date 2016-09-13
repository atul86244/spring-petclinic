#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: enable_webapp
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Clean webapps folder
directory "#{node['tomcat']['base_dir']}/webapps/#{node['tomcat']['base_instance']}" do
  action :delete
  recursive true
end

file "#{node['tomcat']['base_dir']}/webapps/#{node['tomcat']['base_instance']}.war" do
  action :delete
end

file "#{node['tomcat']['base_dir']}/webapps/#{node['tomcat']['base_instance']}.war.zip" do
  action :delete
end