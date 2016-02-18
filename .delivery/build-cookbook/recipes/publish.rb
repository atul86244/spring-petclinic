#
# Cookbook Name:: build-cookbook
# Recipe:: publish
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

log "Executing Publish Phase"

# Remove existing war file, the mvn package command should recreate it
file "#{node['delivery']['workspace']['repo']}/target/petclinic.war" do
  action :delete
end

log "Building artifact"

# Build Package
execute 'mvn package' do
  command 'mvn package'
  cwd node['delivery']['workspace']['repo']
  action :run
end

# Upload Package to S3
require 'rubygems'
#require 'aws-sdk'
require 'aws/s3'

bucket_name = node['build-cookbook']['s3']['bucket_name']
file_name = "#{node['delivery']['workspace']['repo']}/target/petclinic.war"
key = File.basename(file_name)

log "Uploading artifact to S3"

# To Do: Use data bags for AWS Creds
ruby_block 'upload war to S3' do
  block do
    s3 = AWS::S3.new  # Setup .aws/config file on build nodes to read AWS creds.
	s3.buckets[bucket_name].objects[key].write(:file => file_name)    
  end
end

