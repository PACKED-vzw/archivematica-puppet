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
    $mcp_servername     = $archivematica::params::mcp_servername
  ) inherits archivematica::params {

    include nginx # jfryman-nginx
    #include mysql # puppetlabs-mysql
    include uwsgi # engage-uwsgi
    #stdlib
    class { 'apache':
      default_vhost => false,
    }

    # Archivematica only really works on Ubuntu (it uses PPA's, so no debian)
    # Installing from source is not yet supported by this module
    if $os['distro']['id'] != 'Ubuntu' {
      fail('Archivematica can only be installed on Ubuntu-based distributions.')
    }


    # Configure repositories and keys: the repository for the storage service and MCP is shared
    apt::key { 'archivematica':
      id => '5236CA08',
      source => 'https://packages.archivematica.org/1.5.x/key.asc',
    }
    apt::key { 'elasticsearch':
      id => 'D88E42B4',
      source => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
    }
    apt::ppa { 'ppa:archivematica/externals':
      notify => Exec['apt_update'],
    }
    apt::source { 'archivematica':
      location => 'http://packages.archivematica.org/1.5.x/ubuntu',
      release => 'trusty',
      repos => 'main',
      architecture => 'amd64',
      notify => Exec['apt_update'],
    }
    apt::source { 'elasticsearch':
      location => 'http://packages.elasticsearch.org/elasticsearch/1.7/debian',
      release => 'stable',
      repos => 'main',
      notify => Exec['apt_update']
    }

    contain('archivematica::storage_service::install')
    contain('archivematica::storage_service::config')
    contain('archivematica::storage_service::service')
    #contain('archivematica::mcp::install')
    #contain('archivematica::mcp::config')
    #contain('archivematica::mcp::service')

  }
