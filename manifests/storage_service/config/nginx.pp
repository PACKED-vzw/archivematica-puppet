##
# Configure nginx
class archivematica::storage_service::config::nginx inherits archivematica {

  if ! defined(Class['nginx']) {
    class {'nginx':}
  }

  nginx::resource::upstream {'archivematica-storage-service':
    members => [
      'unix:///tmp/am_storage.uwsgi.sock',
    ],
  }

  nginx::resource::vhost {'archivematica-storage-service':
    listen_port          => $archivematica::storage_port,
    client_max_body_size => $archivematica::storage_client_max_body_size,
    use_default_location => false,
  }

  nginx::resource::location {'archivematica-storage-service-static':
    location       => '/static',
    location_alias => '/usr/lib/archivematica/storage-service/assets',
    vhost          => 'archivematica-storage-service',
  }

  nginx::resource::location {'archivematica-storage-service-root':
    location            => '/',
    location_custom_cfg => {
      'uwsgi_pass'         => 'archivematica-storage-service', # eq. to proxy_pass
      'uwsgi_read_timeout' => $archivematica::storage_uwsgi_read_timeout,
      'uwsgi_send_timeout' => $archivematica::storage_uwsgi_send_timeout,
      'include'            => '/etc/nginx/uwsgi_params',
    },
    vhost               => 'archivematica-storage-service',
  }

}
