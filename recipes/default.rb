
#  -------    CHEF-GREENLIB --------

# LICENSETEXT
# 
#   Copyright (C) 2012 : GreenSocs Ltd
#       http://www.greensocs.com/ , email: info@greensocs.com
# 
# The contents of this file are subject to the licensing terms specified
# in the file LICENSE. Please consult this file for restrictions and
# limitations that may apply.
# 
# ENDLICENSETEXT

package "build-essential"
package "cmake"
package "libboost-filesystem1.49-dev"
#package "libboost1.49-dev"
package "git"

directory "#{node[:prefix]}/ModelLibrary/greensocs" do
  action :create
  recursive true
end


bash "Checkout GreenLib" do
  code <<-EOH
# need to specify branch
    git clone  git://git.greensocs.com/greenlib  #{node[:prefix]}/ModelLibrary/greensocs/greenlib.source
  EOH
  creates "#{node[:prefix]}/ModelLibrary/greensocs/greenlib.source"
  environment ({ 'http_proxy' => Chef::Config[:http_proxy] })
end

bash "Update GreenLib" do
  code <<-EOH
    cd #{node[:prefix]}/ModelLibrary/greensocs/greenlib.source
    git pull origin master
  EOH
  environment ({ 'http_proxy' => Chef::Config[:http_proxy] })
end

ruby_block "compile GreenLib" do
  block do
    IO.popen( <<-EOH
       cd #{node[:prefix]}/ModelLibrary/greensocs
       mkdir -p greenlib.build
       cd greenlib.build

       export SYSTEMC_HOME=/usr/local/systemc-2.3.0

       cmake -DCMAKE_INSTALL_PREFIX=#{node[:prefix]}/ModelLibrary/greensocs ../greenlib.source/
       make install | grep -v "Up-to-date:" | grep -v "Installing:"
     EOH
   ) { |f|  f.each_line { |line| puts line } }
  end
end



# remote_file Chef::Config[:file_cache_path]+"/greenlib-1.0.0-Source.tar.gz" do
#   not_if {File.exists?('#{node[:prefix]}/ModelLibrary/greensocs/include')}
#   source "http://www.greensocs.com/files/greenlib-1.0.0-Source.tar.gz"
#   mode "0644"
#   action :create_if_missing
# end

# bash "get GreenLib" do
#   cwd Chef::Config[:file_cache_path]
#   code <<-EOH

#   tar xzf greenlib-1.0.0-Source.tar.gz
#   mkdir greenlib.build
#   cd greenlib.build

#   export SYSTEMC_HOME=/usr/local/systemc-2.3.0

#   cmake -DCMAKE_INSTALL_PREFIX=#{node[:prefix]}/ModelLibrary/greensocs ../greenlib-1.0.0-Source/
#   make install

#   EOH
#   creates "#{node[:prefix]}/ModelLibrary/greensocs/include"
# end
