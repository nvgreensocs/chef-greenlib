
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

#Add these packages to your versions cookbook
#package "build-essential"
#package "cmake"
#package "libboost-filesystem1.49-dev"
#package "git"

directory "#{node[:prefix]}/ModelLibrary/greensocs" do
  action :create
  recursive true
end


bash "Checkout GreenLib" do
  code <<-EOH
  for i in #{node[:prefix]}/bash.profile.d/*; do . $i; done

# need to specify branch
    git clone  git://git.greensocs.com/greenlib  #{node[:prefix]}/ModelLibrary/greensocs/greenlib.source
  EOH
  creates "#{node[:prefix]}/ModelLibrary/greensocs/greenlib.source"
end

bash "Update GreenLib" do
  code <<-EOH
  for i in #{node[:prefix]}/bash.profile.d/*; do . $i; done

    cd #{node[:prefix]}/ModelLibrary/greensocs/greenlib.source
    git pull origin master
    git reset --hard $version_greenlib

  EOH
end

ruby_block "compile GreenLib" do
  block do
     IO.popen(  <<-EOH
       for i in #{node[:prefix]}/bash.profile.d/*; do . $i; done
       # the profile should now include SystemC export SYSTEMC_HOME=/usr/local/systemc-2.3.0

       cd #{node[:prefix]}/ModelLibrary/greensocs
       mkdir -p greenlib.build
       cd greenlib.build

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
