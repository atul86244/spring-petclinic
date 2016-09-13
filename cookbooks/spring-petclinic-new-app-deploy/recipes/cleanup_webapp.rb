#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: enable_webapp
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Clean webapps folder
directory "#{node['tomcat']['base_dir']}/webapps/#{node['tomcat']['base_instance']}" do
  action :delete
  only_if "test -d #{node['tomcat']['base_dir']}/webapps/#{node['tomcat']['base_instance']}"
  recursive true
end

file "#{node['tomcat']['base_dir']}/webapps//#{node['tomcat']['base_instance']}.war" do
  action :delete
  only_if "test -f #{node['tomcat']['base_dir']}/webapps//#{node['tomcat']['base_instance']}.war"
end

file "#{node['tomcat']['base_dir']}/webapps//#{node['tomcat']['base_instance']}.war.zip" do
  action :delete
  only_if "test -f node['tomcat']['base_dir']}/webapps//#{node['tomcat']['base_instance']}.war.zip"
end