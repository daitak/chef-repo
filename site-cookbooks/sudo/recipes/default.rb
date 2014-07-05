#
# Cookbook Name:: sudo
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "use user's PATH when user do sudo" do
  user 'root'
  code <<-EOC
       sudo sed -i -e "s/^\(Defaults *secure_path\)/#\1/g" /etc/sudoers
  EOC
end
