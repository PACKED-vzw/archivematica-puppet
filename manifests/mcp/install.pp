##
# Install MCP
class archivematica::mcp::install inherits archivematica {

  # .my.cnf or debian-sys-maintainer
  if ! defined(Class['mysql::client']) {
    class {'mysql::client':
      package_name => 'mysql-client',
    }
    
    file {'/root/.my.cnf':
      ensure  => present,
      before  => Mysql::Db[$archivematica::mcp_mysql_db],
      content => epp('archivematica/my.cnf.epp',
      {
        mcp_mysql_root_password => $archivematica::mcp_mysql_root_password,
        mcp_mysql_host          => $archivematica::mcp_mysql_host,
      })
    }
  }

  mysql::db {$archivematica::mcp_mysql_db:
    user     => $archivematica::mcp_mysql_user,
    password => $archivematica::mcp_mysql_password,
    dbname   => $archivematica::mcp_mysql_db,
    host     => 'localhost', # TODO: use local ip
    grant    => ['ALL']
  }


  ['archivematica-mcp-server', 'archivematica-mcp-client', 'archivematica-dashboard'].each | $package | {
    package {$package:
      ensure  => installed,
      require => [Mysql::Db[$archivematica::mcp_mysql_db], Exec['apt_update'], Python::Pip['setuptools']],
    }
  }

}