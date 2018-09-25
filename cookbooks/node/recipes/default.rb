#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

apt_update 'update' do
  action :update
end

# provision nodejs from library/recipe
include_recipe('nodejs')

# Using node package manager to install pm2
nodejs_npm "pm2" do
  action :install
end

# provisioning nginx > package
package "nginx" do
  action :install
end

template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  notifies(:restart, 'service[nginx]')
end

link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies(:restart, 'service[nginx]')
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
end

service "nginx" do
  action [:enable, :start]
end
