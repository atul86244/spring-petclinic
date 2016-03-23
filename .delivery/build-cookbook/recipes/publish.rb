#
# Cookbook Name:: build-cookbook
# Recipe:: publish
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


log "Executing Publish Phase"

include_recipe "delivery-truck::publish"

software_version = Time.now.strftime('%F_%H%M')
build_name = "#{node['delivery']['change']['project']}-#{software_version}"

# Remove existing war file, the mvn package command should recreate it
file "#{node['delivery']['workspace']['repo']}/target/#{node['delivery']['change']['project']}*.war" do
  action :delete
end

log "Building artifact"

# Build Package
execute 'mvn package' do
  command 'mvn package'
  cwd node['delivery']['workspace']['repo']
  action :run
end

# Rename war file 
execute 'rename war' do
  action :run
  cwd "#{node['delivery']['workspace']['repo']}/target"
  command "mv petclinic.war #{build_name}.war"
  only_if {::File.exists?("#{node['delivery']['workspace']['repo']}/target/petclinic.war") }
end

# Upload Package to S3
require 'rubygems'
#require 'aws-sdk'
require 'aws/s3'

bucket_name = node['build-cookbook']['s3']['bucket_name']
file_name = "#{node['delivery']['workspace']['repo']}/target/#{build_name}.war"
key = File.basename(file_name)

log "Uploading artifact to S3"

with_server_config do
  # Reading AWS creds from encrypted data bag
  aws_creds = data_bag_item('aws_data', 'aws-creds', IO.read(Chef::Config[:encrypted_data_bag_secret]))
 
 ruby_block 'upload war to S3' do
  block do
    s3 = AWS::S3.new(
	:access_key_id => aws_creds['aws_access_key_id'],
	:secret_access_key => aws_creds['aws_secret_access_key']
     )
    s3.buckets[bucket_name].objects[key].write(:file => file_name)
   end
 end
end

checksum = ''
ruby_block 'get checksum' do
  block do
    checksum = `shasum -a 256 #{file_name}`.split[0]
  end
end

ruby_block 'upload data bag' do
  block do
    with_server_config do
      dbag = Chef::DataBag.new
      dbag.name(node['delivery']['change']['project'])
      dbag.save
      dbag_data = {
        'id' => "app_details",
        'version' => software_version,
        'artifact_location' => "https://s3-us-west-2.amazonaws.com/atul-java-app/#{build_name}.war",
        'artifact_checksum' => checksum,
        'artifact_type' => 'http',
        'delivery_data' => node['delivery']
      }
      dbag_item = Chef::DataBagItem.new
      dbag_item.data_bag(dbag.name)
      dbag_item.raw_data = dbag_data
      dbag_item.save
    end
  end
end

ruby_block 'set the version in the env' do
  block do
    with_server_config do
      begin
        to_env = Chef::Environment.load(get_acceptance_environment)
      rescue Net::HTTPServerException => http_e
        raise http_e unless http_e.response.code == "404"
        Chef::Log.info("Creating Environment #{get_acceptance_environment}")
        to_env = Chef::Environment.new()
        to_env.name(get_acceptance_environment)
        to_env.create
      end

      to_env.override_attributes['applications'] ||= {}
      to_env.override_attributes['applications'][node['delivery']['change']['project']] = software_version
      to_env.save
      ::Chef::Log.info("Set #{node['delivery']['change']['project']}'s version to #{software_version} in #{node['delivery']['change']['project']}.")
    end
  end
end
