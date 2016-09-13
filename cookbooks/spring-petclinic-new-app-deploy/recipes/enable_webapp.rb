#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: enable_webapp
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

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

# Move war file into place for Tomcat to read
execute 'rename_petclinic.war.zip' do
  command 'mv -f petclinic.war.zip petclinic.war'
  cwd "#{tomcat_base_dir}/webapps"
  action :nothing
  notifies :start, "tomcat_service[#{tomcat_service_name}]"
end
