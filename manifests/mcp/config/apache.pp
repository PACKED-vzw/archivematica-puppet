##
# Configure a VHOST for MCP
class archivematica::mcp::config::apache inherits archivematica {

  $vhost = "${archivematica::mcp_servername}_80"

  class { 'apache::mod::wsgi': }

  apache::vhost { $vhost:
    port                => 80,
    servername          => $archivematica::mcp_servername,
    docroot             => '/var/www',
    aliases             => [
      {
        alias => '/media',
        path  => '/usr/share/archivematica/dashboard/media',
      }
    ],
    directories         => [
      {
        path    => '/usr/share/archivematica/dashboard/media',
        options =>  ['FollowSymLinks']
      },
      {
        path    => '/usr/share/archivematica/dashboard/apache',
        options =>  ['FollowSymLinks']
      }
    ],
    wsgi_script_aliases => {
      '/' => '/usr/share/archivematica/dashboard/apache/django.wsgi',
      },
    wsgi_daemon_process => 'dashboard user=archivematicadashboard group=archivematica',
    wsgi_process_group  => 'dashboard',
  }

}
