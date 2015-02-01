
mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password 'password'
  action [:create, :start]
end

mysql_config 'default' do
  source 'magnolia-my.cnf.erb'
  notifies :restart, 'mysql_service[default]'
  action :create
end

mysql_client 'default' do
  action :create
end

mysql_connection_info = {
  :host     => '127.0.0.1',
  :port     => '3306',
  :username => 'root',
  :password => 'password'
}

mysql_database 'magnolia_author' do
  connection mysql_connection_info
  action :create
end

mysql_database 'magnolia_public' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'cms' do
  connection mysql_connection_info
  password 'password'
  action :create
end

mysql_database_user 'cms' do
  connection mysql_connection_info
  database_name 'magnolia_author'
  host '%'
  privileges [:all]
  action :grant
end

mysql_database_user 'cms' do
  connection mysql_connection_info
  database_name 'magnolia_public'
  host '%'
  privileges [:all]
  action :grant
end
