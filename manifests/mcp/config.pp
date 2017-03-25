##
# Configure MCP
class archivematica::mcp::config inherits archivematica {

  include archivematica::mcp::config::nginx
  include archivematica::mcp::config::gearman

  $mcp_gearman_addr = "${archivematica::mcp_gearman_server}:${archivematica::mcp_gearman_port}"
  $mcp_elastic_addr = "${archivematica::mcp_elastic_server}:${archivematica::mcp_elastic_port}";

  file {'/etc/archivematica/archivematicaCommon/dbsettings':
    ensure  => present,
    content => epp('archivematica/dbsettings.epp',
    {
      'mcp_mysql_host'     => $archivematica::mcp_mysql_host,
      'mcp_mysql_db'       => $archivematica::mcp_mysql_db,
      'mcp_mysql_user'     => $archivematica::mcp_mysql_user,
      'mcp_mysql_password' => $archivematica::mcp_mysql_password,
      }),
    require => [Package['archivematica-mcp-server']],
  }

  file {'/etc/archivematica/MCPServer/serverConfig.conf':
    ensure  => present,
    content => epp('archivematica/serverConfig.conf.epp',
    {
      'mcp_gearman_addr' => $mcp_gearman_addr,
      }),
    require => Package['archivematica-mcp-server'],
  }

  file {'/etc/archivematica/MCPClient/clientConfig.conf':
    ensure  => present,
    content => epp('archivematica/clientConfig.conf.epp',
    {
      'mcp_gearman_addr' => $mcp_gearman_addr,
      'mcp_elastic_addr' => $mcp_elastic_addr
      }),
    require => Package['archivematica-mcp-client'],
  }

  if ! defined(Class['clamav']) {
    class {'clamav':
      manage_clamd     => true,
      manage_freshclam => true,
    }
  }

  include archivematica::mcp::config::elasticsearch

}
