#
# Cookbook:: yum
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute "yum update" do
  command "yum update -y"
end
