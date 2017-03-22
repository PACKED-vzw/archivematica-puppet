##
# Configure uwsgi
class archivematica::storage_service::config::uwsgi inherits archivematica {

  $django_secret_key = fqdn_rand_string(512)

  if ! defined(Class['uwsgi']) {
    class {'uwsgi':
      install_pip => false,
      require     => [Python::Pip['setuptools'], Class['python']]
    }
  }

  file { '/etc/uwsgi':
    ensure => directory,
  }

  file { '/etc/uwsgi/apps-enabled/storage.ini':
    ensure  => absent,
    require => File['/etc/uwsgi'],
  }

  uwsgi::app {'am_storage':
    uid                   => 'archivematica',
    gid                   => 'archivematica',
    application_options   => {
      'master'       => true,
      'processes'    => 10,
      'socket'       => '/tmp/am_storage.uwsgi.sock',
      'chmod-socket' => '666',
      'vacuum'       => true,
      'chdir'        => '/usr/lib/archivematica/storage-service',
      'module'       => 'storage_service.wsgi',
      'home'         => '/usr/share/python/archivematica-storage-service',
    },
    environment_variables => {
        'DJANGO_SECRET_KEY'      => $django_secret_key,
        'DJANGO_SETTINGS_MODULE' => 'storage_service.settings.production',
        'DJANGO_STATIC_ROOT'     => '/var/archivematica/storage-service/assets',
        'EMAIL_HOST'             => $archivematica::storage_uwsgi_email_host,
        'EMAIL_HOST_PASSWORD'    => $archivematica::storage_uwsgi_email_host_password,
        'EMAIL_HOST_USER'        => $archivematica::storage_uwsgi_email_host_user,
        'EMAIL_PORT'             => $archivematica::storage_uwsgi_email_port,
        'SS_DB_HOST'             => $archivematica::storage_uwsgi_db_host,
        'SS_DB_NAME'             => $archivematica::storage_uwsgi_db_name,
        'SS_DB_PASSWORD'         => $archivematica::storage_uwsgi_db_password,
        'SS_DB_USER'             => $archivematica::storage_uwsgi_db_user,

    },
    require               => [File['/etc/uwsgi'], Package['archivematica-storage-service']],
  }

}
