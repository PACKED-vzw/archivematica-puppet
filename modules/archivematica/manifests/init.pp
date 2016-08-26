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
    $configure_mysql    = $archivematica::params::configure_mysql,
    $configure_gearman  = $archivematica::params::configure_gearman,
    $configure_apache   = $archivematica::params::configure_apache,
    $configure_uwsgi    = $archivematica::params::configure_uwsgi,
    $configure_nginx    = $archivematica::params::configure_nginx,
    $configure_clamav   = $archivematica::params::configure_clamav,
  ) inherits archivematica::params {

    if $configure_uwsgi == true {
        include uwsgi
    } else {
        if !defined(Class['uwsgi']) {
            fail('UWSGI is required for this module to function. Set $configure_uwsgi to true or include the uwsgi module.')
        }
    }

    if $configure_nginx == true {
        include nginx
    } else {
        if !defined(Class['nginx']) {
            fail('NGINX is required for this module to function. Set $configure_nginx to true or include the nginx module.')
        }
    }

    if $configure_apache == true {
        class { 'apache':
            default_vhost => false,
        }
    } else {
        if !defined(Class['apache']) {
            fail('APACHE is required for this module to function. Set $configure_apache to true or include the apache module.')
        }
    }

    if $configure_gearman != true {
        if !defined(Class['gearman']) {
            fail('GEARMAN is required for this module to function. Set $configure_gearman to true or include the gearman module.')
        }
    }

    if $configure_clamav != true {
        if !defined(Class['clamav']) {
            fail('CLAMAV is required for this module to function. Set $configure_clamav to true or include the clamav module.')
        }
    }

    if $configure_elastic != true {
        if !defined(Class['elastic']) {
            fail('ELASTIC is required for this module to function. Set $configure_elastic to true or include the elastic module.')
        }
    }

    # jfryman-nginx
    #include mysql # puppetlabs-mysql
    # engage-uwsgi
    #stdlib
    #edestecd-clamav
    #puppetlabs-apt
    #puppetlabs-apache
    #elasticsearch-elasticsearch? (not used now, no configuration needed) => for restarting after installation
    #saz-gearman

    ##
    # What are we going to do with pre-managed ealstic, gearman, mysql and apache?
    # Create $configure_foo flags?

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
    contain('archivematica::mcp::install')
    contain('archivematica::mcp::config')
    contain('archivematica::mcp::service')

  }
