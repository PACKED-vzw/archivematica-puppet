class archivematica::mcp::config inherits archivematica {

  include archivematica::mcp::config::apache
  include archivematica::mcp::config::gearman

  $mcp_gearman_addr = "${mcp_gearman_server}:${$mcp_gearman_port}"

  file {'/etc/archivematica/archivematicaCommon/dbsettings':
    ensure  => present,
    content => epp('archivematica/dbsettings.epp',
    {
      'mcp_mysql_host'     => $mcp_mysql_host,
      'mcp_mysql_db'       => $mcp_mysql_db,
      'mcp_mysql_user'     => $mcp_mysql_user,
      'mcp_mysql_password' => $mcp_mysql_password,
      }),
    require => [File['/etc/dbconfig-common'], Package['archivematica-mcp-server']],
  }

  file {'/etc/archivematica/MCPServer/serverConfig.conf':
    ensure => present,
    content => epp('archivematica/serverConfig.conf.epp',
    {
      'mcp_gearman_addr' => "$mcp_gearman_addr",
      }),
    require => Package['archivematica-mcp-server'],
  }

  file {'/etc/archivematica/MCPClient/clientConfig.conf':
    ensure => present,
    content => epp('archivematica/clientConfig.conf.epp',
    {
      'mcp_gearman_addr' => "$mcp_gearman_addr",
      }),
    require => Package['archivematica-mcp-client'],
  }

  if $configure_clamav == true {
    class { 'clamav':
      manage_clamd  => true,
      manage_freshclam => true,
    }
  }

  if $configure_elastic == true {
    class { 'elasticsearch':
        api_host => $mcp_elastic_server,
        api_port => $mcp_elastic_port,
    }
  }

}
