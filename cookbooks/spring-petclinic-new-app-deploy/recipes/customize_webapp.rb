#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: customize_webapp
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

template '#{tomcat_base_dir}/webapps/#{tomcat_service_name}/resources/css/petclinic.css' do
  source 'petclinic.css.erb'
  owner 'tomcat_petclinic'
  group 'tomcat_petclinic'
  mode '0644'
end

template '#{tomcat_base_dir}/webapps/#{tomcat_service_name}/WEB-INF/classes/messages/messages.properties' do
  source 'messages.properties.erb'
  owner 'tomcat_petclinic'
  group 'tomcat_petclinic'
  mode '0644'
end
