##
# Configure nginx for the dashboard
class archivematica::mcp::config::nginx () inherits archivematica {

  if ! defined(Class['nginx']) {
    class {'nginx':}
  }

  nginx::resource::upstream {'archivematica-dashboard-upstream':
    members => [
        '127.0.0.1:8002',
    ]
  }

  nginx::resource::vhost {'archivematica-dashboard':
    server_name          => [$archivematica::mcp_servername],
    client_max_body_size => '256',
    use_default_location => false,
  }

  nginx::resource::location {'archivematica-dashboard-root':
    location            => '/',
    vhost               => 'archivematica-dashboard',
    location_custom_cfg => {
        proxy_pass         => 'http://archivematica-dashboard-upstream',
        proxy_set_header   => [
            'Host $http_host',
            'X-Forwarded-For $proxy_add_x_forwarded_for'
        ],
        proxy_redirect     => 'off',
        proxy_buffering    => 'off',
        proxy_read_timeout => '172800s',
    }
  }

  nginx::resource::location {'archivematica-storage-service-media':
    location       => '/media',
    location_alias => '/usr/share/archivematica/dashboard/media',
    vhost          => 'archivematica-storage-service',
  }
}