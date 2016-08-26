class archivematica::mcp::install inherits archivematica {

  file {'/etc/dbconfig-common':
    ensure => directory,
  }

  file {'/etc/dbconfig-common/archivematica-mcp-server.conf':
    ensure  => present,
    content => epp('archivematica/dbconfig-common/archivematica-mcp-server.conf.epp',
    {
      'mcp_mysql_db'       => $mcp_mysql_db,
      'mcp_mysql_user'     => $mcp_mysql_user,
      'mcp_mysql_password' => $mcp_mysql_password,
      }),
    require => File['/etc/dbconfig-common'],
  }

  file {'/var/cache/debconf/archivematica-mcp-server.preseed':
    ensure  => present,
    content => epp('archivematica/archivematica-mcp-server.preseed.epp',
    {
      'mcp_mysql_root_password' => $mcp_mysql_root_password
      }),
  }

  if $configure_mysql == true {
    class {'::mysql::server':
        root_password => $mcp_mysql_root_password,
        before => [File['/etc/dbconfig-common/archivematica-mcp-server.conf'], File['/var/cache/debconf/archivematica-mcp-server.preseed']]
    }
  }

  Apt::Key['elasticsearch']->
  Apt::Key['archivematica']->
  Apt::Source['archivematica']->
  Apt::Ppa['ppa:archivematica/externals']->
  Exec['apt_update']->
  package { 'archivematica-mcp-server':
    ensure       => installed,
    responsefile => '/var/cache/debconf/archivematica-mcp-server.preseed',
    require      => [File['/etc/dbconfig-common/archivematica-mcp-server.conf'], File['/var/cache/debconf/archivematica-mcp-server.preseed']],
  }->
  package { 'archivematica-mcp-client':
    ensure  => installed,
  }->
  package { 'archivematica-dashboard':
    ensure  => installed,
    responsefile => '/var/cache/debconf/archivematica-mcp-server.preseed',
    require      => [File['/etc/dbconfig-common/archivematica-mcp-server.conf'], File['/var/cache/debconf/archivematica-mcp-server.preseed']],
  }



}
#COnfigure MYSQL!
