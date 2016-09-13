#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: enable_webapp
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Prepare webapps directory
include_recipe 'spring-petclinic-new-app-deploy::cleanup_webapp' 

# Download war to tomcat webapps
app_data = data_bag_item('spring-petclinic', 'app_details')
remote_file "#{node['tomcat']['base_dir']}/webapps/#{node['tomcat']['base_instance']}.war.zip" do
  owner 'root'
  group 'root'
  mode '0775'
  source app_data['artifact_location']
  notifies :run, "execute[rename_#{node['tomcat']['base_instance']}.war.zip]", :immediately
end

# Move war file into place for Tomcat to read
execute "rename_#{node['tomcat']['base_instance']}.war.zip" do
  command "mv -f #{node['tomcat']['base_instance']}.war.zip #{node['tomcat']['base_instance']}.war"
  cwd "#{node['tomcat']['base_dir']}/webapps"
  action :nothing
  only_if "test -f #{node['tomcat']['base_dir']}/webapps/#{node['tomcat']['base_instance']}.war.zip"
  notifies :start, "tomcat_service[#{node['tomcat']['base_instance']}]", :immediately
end
