#
# Cookbook Name:: spring-petclinic-new-app-deploy
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'spring-petclinic-new-app-deploy::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.1') do |node, server|
		  server.create_data_bag('spring-petclinic', {
		    'app_details' => {
		       'version' => '1.0.0',
               'artifact_location' => 'https://s3-us-west-2.amazonaws.com/emea-techcft/petclinic-1.0.0.war',
               'artifact_type' => 'http',
               'delivery_data' => ''
		    }
		  })
		end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
