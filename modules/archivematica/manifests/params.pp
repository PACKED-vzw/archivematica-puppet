class archivematica::params {

  $storage_webserver  = 'nginx'
  $storage_port       = '8000'
  $storage_fqdn       = 'localhost'
  $storage_client_max_body_size = '256'
  $storage_uwsgi_read_timeout = '3600'
  $storage_uwsgi_send_timeout = '3600'
  $storage_uwsgi_db_host  = ''
  $storage_uwsgi_db_name  = '/var/archivematica/storage-service/storage.db'
  $storage_uwsgi_db_password  = ''
  $storage_uwsgi_db_user  = ''
  $storage_uwsgi_email_host = 'localhost'
  $storage_uwsgi_email_host_password  = ''
  $storage_uwsgi_email_host_user  = ''
  $storage_uwsgi_email_port = '25'
  $mcp_mysql_root_password  = 'mV6CEe4N3WOIdRFEPwjAXkCHwGDHAgrVWTMx7kLrt5aLioOIQ3VsZh8bziZBYns' # make either this or $mcp_msyql_password required => if the latter, assume user exists
  $mcp_mysql_user     = 'archivematica'
  $mcp_mysql_password = 'demo'
  $mcp_mysql_host     = 'localhost'
  $mcp_mysql_db       = 'MCP'
  $mcp_servername     = 'localhost'

}
