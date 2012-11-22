package "cmake"

remote_file Chef::Config[:file_cache_path]+"/greenlib-1.0.0-Source.tar.gz" do
  source "http://www.greensocs.com/files/greenlib-1.0.0-Source.tar.gz"
  mode "0644"
  action :create_if_missing
end


bash "Create greensocs dir in Model Library" do
  code <<-EOH
    mkdir -p /vagrant/ModelLibrary/greensocs/
  EOH
  creates "/vagrant/ModelLibrary/greensocs"
end


bash "get GreenLib" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH

  tar xzf greenlib-1.0.0-Source.tar.gz
  mkdir greenlib.build
  cd greenlib.build

  export SYSTEMC_HOME=/usr/local/systemc-2.3.0

  cmake -DCMAKE_INSTALL_PREFIX=/vagrant/ModelLibrary/greensocs ../greenlib-1.0.0-Source/

  EOH
  creates "/vagrant/ModelLibrary/greensocs/include"
end
