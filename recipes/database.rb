
#include_recipe 'mysql2_chef_gem'
package "libmysqlclient-dev"

mysql_client 'default' do
  action :create
end

#chef_gem "mysql2"

mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'huginn-mysql' do
  port '3306'
  version '5.5'
  initial_root_password 'password'
  action [:create, :start]
end

# Create a mysql database
mysql_database 'huginn_production' do
  connection(
    :host     => '127.0.0.1',
    :username => 'root',
    :password => node['huginn']['db']['password']
  )
  action :create
end

# Externalize conection info in a ruby hash
mysql_connection_info = {
  :host     => '127.0.0.1',
  :username => 'root',
  :password => 'password'
  #node['mysql']['server_root_password']
}

# grant select,update,insert privileges to all tables in foo db from all hosts, requiring connections over SSL
mysql_database_user 'huginn' do
  connection mysql_connection_info
  password 'super_secret'
  database_name 'huginn_production'
  host '%'
  privileges [:select,:update,:insert]
  require_ssl true
  action :grant
end

