class archivematica::storage_service::config::nginx inherits archivematica {

  $vhost = "${storage_fqdn}_${storage_port}"

  nginx::resource::upstream { 'storage':
    members => [
      'unix:///tmp/am_storage.uwsgi.sock',
    ],
  }
  nginx::resource::vhost { "$vhost":
    listen_port => $storage_port,
    client_max_body_size => $storage_client_max_body_size,
    use_default_location => false,
  }
  nginx::resource::location { "/static":
    location_alias => '/usr/lib/archivematica/storage-service/assets',
    vhost => "$vhost",
  }
  nginx::resource::location { "/":
    location_custom_cfg => {
      'uwsgi_pass' => 'storage', # eq. to proxy_pass
      'uwsgi_read_timeout' => $storage_uwsgi_read_timeout,
      'uwsgi_send_timeout' => $storage_uwsgi_send_timeout,
      'include' => '/etc/nginx/uwsgi_params',
    },
    vhost => "$vhost",
  }

}
