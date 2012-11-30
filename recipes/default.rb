
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
package "libboost1.49-dev"

remote_file Chef::Config[:file_cache_path]+"/greenlib-1.0.0-Source.tar.gz" do
  source "http://www.greensocs.com/files/greenlib-1.0.0-Source.tar.gz"
  mode "0644"
  action :create_if_missing
end


directory "/vagrant/ModelLibrary/greensocs" do
  action :create
  recursive true
end


bash "get GreenLib" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH

  tar xzf greenlib-1.0.0-Source.tar.gz
  mkdir greenlib.build
  cd greenlib.build

  export SYSTEMC_HOME=/usr/local/systemc-2.3.0

  cmake -DCMAKE_INSTALL_PREFIX=/vagrant/ModelLibrary/greensocs ../greenlib-1.0.0-Source/
  make install

  EOH
  creates "/vagrant/ModelLibrary/greensocs/include"
end
