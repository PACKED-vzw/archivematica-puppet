##
# Install and configure Archivematica (https://www.archivematica.org/en/)
class archivematica (
    $storage_webserver  = $archivematica::params::storage_webserver,
    $storage_port       = $archivematica::params::storage_port,
    $storage_fqdn       = $archivematica::params::storage_fqdn,
    $storage_client_max_body_size = $archivematica::params::storage_client_max_body_size,
    $storage_uwsgi_read_timeout = $archivematica::params::storage_uwsgi_read_timeout,
    $storage_uwsgi_send_timeout = $archivematica::params::storage_uwsgi_send_timeout,
    $storage_uwsgi_db_host  = $archivematica::params::storage_uwsgi_db_host,
    $storage_uwsgi_db_name  = $archivematica::params::storage_uwsgi_db_name,
    $storage_uwsgi_db_password  = $archivematica::params::storage_uwsgi_db_password,
    $storage_uwsgi_db_user  = $archivematica::params::storage_uwsgi_db_user,
    $storage_uwsgi_email_host = $archivematica::params::storage_uwsgi_email_host,
    $storage_uwsgi_email_host_password  = $archivematica::params::storage_uwsgi_email_host_password,
    $storage_uwsgi_email_host_user  = $archivematica::params::storage_uwsgi_email_host_user,
    $storage_uwsgi_email_port = $archivematica::params::storage_uwsgi_email_port,
    $mcp_mysql_root_password  = $archivematica::params::mcp_mysql_root_password,
    $mcp_mysql_host     = $archivematica::params::mcp_mysql_host,
    $mcp_mysql_db       = $archivematica::params::mcp_mysql_db,
    $mcp_mysql_user     = $archivematica::params::mcp_mysql_user,
    $mcp_mysql_password = $archivematica::params::mcp_mysql_password,
    $mcp_servername     = $archivematica::params::mcp_servername,
    $mcp_gearman_server = $archivematica::params::mcp_gearman_server,
    $mcp_gearman_port   = $archivematica::params::mcp_gearman_port,
    $mcp_elastic_server = $archivematica::params::mcp_elastic_server,
    $mcp_elastic_port   = $archivematica::params::mcp_elastic_port,
  ) inherits archivematica::params {


    ##
    # What are we going to do with pre-managed ealstic, gearman, mysql and apache?
    # Create $configure_foo flags?

    # Archivematica only really works on Ubuntu (it uses PPA's, so no debian)
    # Installing from source is not yet supported by this module
    if $::os['name'] != 'Ubuntu' {
      fail('Archivematica can only be installed on Ubuntu-based distributions.')
    }

    include archivematica::install
    include archivematica::config

  }
