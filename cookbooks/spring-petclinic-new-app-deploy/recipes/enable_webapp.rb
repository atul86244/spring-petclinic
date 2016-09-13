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

# Download war to tomcat webapps
app_data = data_bag_item('spring-petclinic', 'app_details')
remote_file "#{node['tomcat']['base_dir']}/webapps/petclinic.war.zip" do
  owner 'root'
  group 'root'
  mode '0775'
  source app_data['artifact_location']
  notifies :run, 'execute[rename_petclinic.war.zip]'
end

# Move war file into place for Tomcat to read
execute 'rename_petclinic.war.zip' do
  command 'mv -f petclinic.war.zip petclinic.war'
  cwd "#{node['tomcat']['base_dir']}/webapps"
  action :nothing
  notifies :start, "tomcat_service[#{node['tomcat']['base_instance']}]"
end
