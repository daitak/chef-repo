#
# Cookbook Name:: dev_env
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{vim-enhanced zsh screen ctags}.each do |pkg|
  package pkg do
    action :install
  end
end

DIRNAME="home_settings"
git "/home/#{node['dev_env']['user']}/#{DIRNAME}" do
  repository "https://github.com/daitak/home_settings.git"
  revision "master"
  action :sync
end

%w{.vim .screenrc .vimrc .zshrc cdd}.each do |obj|
  link "/home/#{node['dev_env']['user']}/#{obj}" do
    to "/home/#{node['dev_env']['user']}/#{DIRNAME}/#{obj}"
  end
end

bash "Set User's shell to zsh" do
    code <<-EOT
        chsh -s /bin/zsh #{node['dev_env']['user']}
          EOT
            not_if 'test "/bin/zsh" = "$(grep #{node["dev_env"]["user"]} /etc/passwd | cut -d: -f7)"'
end
