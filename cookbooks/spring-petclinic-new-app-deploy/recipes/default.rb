#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Specific Application Configuration
app_data = data_bag_item('spring-petclinic', 'app_details')
node.default['java']['jdk_version'] = '7'
tomcat_service_name = node['tomcat']['base_instance']
tomcat_base_dir = "/opt/tomcat_#{tomcat_service_name}"

# Install prerequisites
include_recipe 'spring-petclinic-new-app-deploy::install_prereqs' 

# Laydown default middleware application
include_recipe 'spring-petclinic-new-app-deploy::install_middleware' 

# Secure Middleware Application
include_recipe 'spring-petclinic-new-app-deploy::secure_middleware' 

# Enable & Install Web Application)
include_recipe 'spring-petclinic-new-app-deploy::enable_webapp' 

# Customize Web Application
include_recipe 'spring-petclinic-new-app-deploy::customize_webapp' 
