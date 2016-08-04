#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: tomcat_hardening
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

tomcat_base_dir = "/opt/tomcat_#{node['tomcat']['base_instance']}"

%w(bin conf logs temp).each do |dir_name|
  directory "#{tomcat_base_dir}/#{dir_name}" do
    mode 0750
  end
end

cookbook_file "/opt/tomcat_#{node['tomcat']['base_instance']}/conf/server.xml" do
    source "server.xml"
    owner 'tomcat_petclinic'
    group 'tomcat_petclinic'
    mode 0600
end

cookbook_file "/opt/tomcat_#{node['tomcat']['base_instance']}/conf/web.xml" do
    source "web.xml"
    owner 'tomcat_petclinic'
    group 'tomcat_petclinic'
    mode 0600
end

cookbook_file "/opt/tomcat_#{node['tomcat']['base_instance']}/bin/catalina.sh" do
    source "catalina.sh"
    owner 'tomcat_petclinic'
    group 'tomcat_petclinic'
    mode 0755
end

