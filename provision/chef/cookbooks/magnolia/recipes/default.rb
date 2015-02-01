#
# Cookbook Name:: magnolia
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

package "curl" do
  action :install
end

package "unzip" do
  action :install
end

include_recipe "magnolia::java"
include_recipe "maven::default"
include_recipe "magnolia::mysql"
include_recipe "magnolia::install"
