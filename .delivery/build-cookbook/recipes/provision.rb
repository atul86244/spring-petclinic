#
# Cookbook Name:: build-cookbook
# Recipe:: provision
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

log "Executing provision phase"

include_recipe 'delivery-truck::provision'
