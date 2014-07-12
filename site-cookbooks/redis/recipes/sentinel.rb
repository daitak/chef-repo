# Set up redis sentinel
# 
include_recipe 'sudo::default'

user "redis" do
  action :modify
  shell "/bin/bash"
end

service "redis-sentinel" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/var/lib/redis/failover.sh" do
  source "failover.sh.erb"
  owner "redis"
  group "root"
  mode 0755
  notifies :restart, "service[redis-sentinel]"  
end

template "/etc/redis-sentinel.conf" do
  source "redis-sentinel.conf.erb"
  owner "redis"
  group "root"
  mode 0644
  notifies :restart, "service[redis-sentinel]"  
end

if node['redis']['role'] == "master" then
  bash "Add VIP" do
    user 'root'
    code <<-EOC
      ip addr add #{node['sentinel']['vip']}/#{node['sentinel']['netmask']} dev #{node['sentinel']['interface']}
    EOC
    not_if "ip addr show | grep inet | grep #{node['sentinel']['interface']} | grep #{node['sentinel']['vip']}/#{node['sentinel']['netmask']}"
  end
else
  bash "Delete VIP" do
    user 'root'
    code <<-EOC
      ip addr del #{node['sentinel']['vip']}/#{node['sentinel']['netmask']} dev #{node['sentinel']['interface']}
    EOC
    only_if "ip addr show | grep inet | grep #{node['sentinel']['interface']} | grep #{node['sentinel']['vip']}/#{node['sentinel']['netmask']}"
  end
end
