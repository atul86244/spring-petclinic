#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: install_middleware
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install Tomcat
tomcat_install node['tomcat']['base_instance'] do
  version "#{node['tomcat']['version']}"
end

tomcat_service node['tomcat']['base_instance'] do
  action [:enable, :stop]
end
