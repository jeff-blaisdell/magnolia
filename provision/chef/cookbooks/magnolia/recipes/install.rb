
# Shared Configuration
magnolia_catalina_home = "#{node['magnolia']['install_dir']}/magnolia/apache-tomcat-7.0.47"
magnolia_author_webapp = "#{magnolia_catalina_home}/webapps/magnoliaAuthor"
magnolia_public_webapp = "#{magnolia_catalina_home}/webapps/magnoliaPublic"
magnolia_context_xml = "#{magnolia_catalina_home}/conf/context.xml"
init_command = "#{magnolia_catalina_home}/bin/magnolia_control.sh"
derby_driver_version = "10.5.3.0_1"
mysql_driver_version = "5.1.34"

# Magnolia Author Instance Configuration
magnolia_author_jackrabbit_repo = "#{magnolia_author_webapp}/WEB-INF/config/repo-conf"
magnolia_author_jackrabbit_config = "#{magnolia_author_jackrabbit_repo}/jackrabbit-bundle-mysql-search.xml"
magnolia_author_config_default = "#{magnolia_author_webapp}/WEB-INF/config/default"
magnolia_author_properties = "#{magnolia_author_config_default}/magnolia.properties"
magnolia_author_lib = "#{magnolia_author_webapp}/WEB-INF/lib"
magnolia_author_derby_driver = "#{magnolia_author_lib}/derby-#{derby_driver_version}.jar"
magnolia_author_repo_root = "/var/magnolia-author"
magnolia_author_repo_home = "#{magnolia_author_repo_root}/repo/magnolia/workspaces"

# Magnolia Public Instance Configuration
magnolia_public_jackrabbit_repo = "#{magnolia_public_webapp}/WEB-INF/config/repo-conf"
magnolia_public_jackrabbit_config = "#{magnolia_public_jackrabbit_repo}/jackrabbit-bundle-mysql-search.xml"
magnolia_public_config_default = "#{magnolia_public_webapp}/WEB-INF/config/default"
magnolia_public_properties = "#{magnolia_public_config_default}/magnolia.properties"
magnolia_public_lib = "#{magnolia_public_webapp}/WEB-INF/lib"
magnolia_public_derby_driver = "#{magnolia_public_lib}/derby-#{derby_driver_version}.jar"
magnolia_public_repo_root = "/var/magnolia-public"
magnolia_public_repo_home = "#{magnolia_public_repo_root}/repo/magnolia/workspaces"

# Create Users / Groups
user "magnolia" do
    system true
    action :create
end

group "magnolia" do
    members ['magnolia']
    action :create
end

# Create Magnolia Workspaces
directory "#{magnolia_author_repo_home}" do
  owner 'magnolia'
  group 'magnolia'
  recursive true
  action :create
end

execute "Set ownership" do
    command "chown -R magnolia #{magnolia_author_repo_root} && chgrp -R magnolia #{magnolia_author_repo_root}"
end

directory "#{magnolia_public_repo_home}" do
  owner 'magnolia'
  group 'magnolia'
  recursive true
  action :create
end

execute "Set ownership" do
    command "chown -R magnolia #{magnolia_public_repo_root} && chgrp -R magnolia #{magnolia_public_repo_root}"
end

# Retrieve and Decompress Magnolia Archive.
ark "magnolia" do
    extension "zip"
    url node['magnolia']['source_url']
    path node['magnolia']['install_dir']
    owner 'magnolia'
    group 'magnolia'
    checksum '4eb8382003bcdac9cf5712f4a65ba772a6113eb2c740ab2b993990f342a2136f'
    action :put
end

# Replace Derby JDBC Drivers with MySQL
maven 'mysql-connector-java' do
    group_id 'mysql'
    version  "#{mysql_driver_version}"
    dest     "#{magnolia_catalina_home}/lib"
end

file "#{magnolia_author_derby_driver}" do
  action :delete
end

file "#{magnolia_public_derby_driver}" do
  action :delete
end

# Create Tomcat Configuration
template "#{magnolia_context_xml}" do
    source "magnolia-context.xml.erb"
    group 'magnolia'
    owner 'magnolia'
    action :create
end

# Configure Magnolia Author Instance
directory "#{magnolia_author_jackrabbit_repo}" do
  owner 'magnolia'
  group 'magnolia'
  recursive true
  action :create
end

template "#{magnolia_author_jackrabbit_config}" do
    source "magnolia-author-jackrabbit-config.xml.erb"
    group 'magnolia'
    owner 'magnolia'
    action :create
end

directory "#{magnolia_author_config_default}" do
  owner 'magnolia'
  group 'magnolia'
  recursive true
  action :create
end

template "#{magnolia_author_properties}" do
    source "magnolia-author.properties.erb"
    group 'magnolia'
    owner 'magnolia'
    action :create
end

# Create an Upstart Service for Magnolia CMS
template "/etc/init/magnolia.conf" do
    source "magnolia.conf.erb"
    action :create
end

service "magnolia" do
    init_command "#{init_command}"
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
end

# Configure Magnolia Public Instance
# On initial start of magnolia service it seems to stub out remainder
# of public instance.  So we need to configure instance after init.
template "#{magnolia_public_jackrabbit_config}" do
    source "magnolia-public-jackrabbit-config.xml.erb"
    group 'magnolia'
    owner 'magnolia'
    action :create
end

template "#{magnolia_public_properties}" do
    source "magnolia-public.properties.erb"
    group 'magnolia'
    owner 'magnolia'
    action :create
end
