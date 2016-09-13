#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: customize_webapp
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

template "#{node['tomcat']['base_dir']}/webapps/#{node['tomcat']['base_instance']}/resources/css/petclinic.css" do
  source 'petclinic.css.erb'
  owner 'tomcat_petclinic'
  group 'tomcat_petclinic'
  mode '0644'
end

template "#{node['tomcat']['base_dir']}/webapps/#{node['tomcat']['base_instance']}/WEB-INF/classes/messages/messages.properties" do
  source 'messages.properties.erb'
  owner 'tomcat_petclinic'
  group 'tomcat_petclinic'
  mode '0644'
end
