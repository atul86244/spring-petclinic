#
# Cookbook Name:: build-cookbook
# Recipe:: deploy
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

node.default['delivery']['config']['delivery-truck']['deploy']['search'] = "expanded_run_list:java_app_deploy*"
include_recipe 'delivery-truck::deploy'
